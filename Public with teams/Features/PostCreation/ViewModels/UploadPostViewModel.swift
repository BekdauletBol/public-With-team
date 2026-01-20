import SwiftUI
import PhotosUI
import Combine

@MainActor
class UploadPostViewModel: ObservableObject {
	// 1. Form Fields
	@Published var title = ""
	@Published var description = ""
	@Published var priceString = ""
	@Published var selectedCategory: PostCategory = .other
	
	@Published var postType: PostType = .sell {
		didSet {
			title = ""
			description = ""
			priceString = ""
			postImage = nil
			selectedItem = nil
		}
	}
	
	@Published var selectedItem: PhotosPickerItem? {
		didSet { Task { await loadImage() } }
	}
	@Published var postImage: UIImage?
	
	@Published var isLoading = false
	@Published var didUpload = false
	
	func loadImage() async {
		guard let data = try? await selectedItem?.loadTransferable(type: Data.self) else { return }
		self.postImage = UIImage(data: data)
	}
	
	func uploadPost() async {
		guard let user = AuthService.shared.currentUser else {
			print("DEBUG: No user found")
			return
		}
		
		if postType == .sell && postImage == nil {
			print("DEBUG: Selling requires a photo.")
			return
		}
		
		isLoading = true
		
		do {
			var imageUrl: String? = nil
			
			if let image = postImage {
				imageUrl = try await ImageUploader.uploadImage(image: image)
			}
			
			let newPost = Post(
				id: UUID().uuidString,
				ownerId: user.id,
				title: title,
				description: description,
				type: postType,
				price: Double(priceString),
				imageUrl: imageUrl,
				phoneNumber: user.phone_number,
				telegramHandle: user.telegram_handle,
				category: selectedCategory,
				status: .available,
				timestamp: Date()
			)
			
			try await PostService.uploadPost(newPost)
			self.didUpload = true
			
		} catch {
			print("❌ DEBUG ERROR: Upload failed: \(error.localizedDescription)")
		}
		
		isLoading = false
	}
	
	func reset() {
		title = ""
		description = ""
		priceString = ""
		postType = .sell
		selectedCategory = .other
		postImage = nil
		selectedItem = nil
		didUpload = false
	}
}
