import SwiftUI
import PhotosUI
import Combine

@MainActor
class UploadPostViewModel: ObservableObject {
	// Form Fields
	@Published var title = ""
	
	@Published var description = ""
	@Published var priceString = ""
	@Published var postType: PostType = .sell
	@Published var selectedCategory: PostCategory = .other

	
	// Image Handling
	@Published var selectedItem: PhotosPickerItem? {
		didSet { Task { await loadImage() } }
	}
	
	@Published var postImage: UIImage?
	
	// UI State
	@Published var isLoading = false
	@Published var didUpload = false
	
	func loadImage() async {
		guard let data = try? await selectedItem?.loadTransferable(type: Data.self) else { return }
		self.postImage = UIImage(data: data)
	}
	
	func uploadPost() async {
		// Get the logged-in student's profile
		guard let user = AuthService.shared.currentUser else {
			print("DEBUG: No user logged in")
			return
		}
		
		//Ensure we have an image to upload
		guard let image = postImage else { return }
		
		isLoading = true
		
		do {
			//Upload the image first to Supabase Storage
			let imageUrl = try await ImageUploader.uploadImage(image: image)
			
			// Create the post object using the 'user' data including the new Telegram handle
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
			
			//Save to Supabase
			try await PostService.uploadPost(newPost)
			
			self.didUpload = true
			
		} catch {
			print("DEBUG: Upload failed: \(error)")
		}
		
		isLoading = false
	}
	
	func reset() {
		title = ""
		description = ""
		priceString = ""
		postImage = nil
		selectedItem = nil
		didUpload = false
	}
}
