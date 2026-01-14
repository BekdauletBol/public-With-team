import SwiftUI
import PhotosUI

struct UploadPostView: View {
	@StateObject private var viewModel = UploadPostViewModel()
	@Environment(\.dismiss) var dismiss
	
	var body: some View {
		NavigationStack {
			Form {
				Section("Photos") {
					let currentImage = viewModel.postImage
					
					PhotosPicker(selection: $viewModel.selectedItem, matching: .images) {
						if let currentImage {
							Image(uiImage: currentImage)
								.resizable()
								.scaledToFill()
								.frame(height: 200)
								.cornerRadius(10)
								.clipped()
						} else {
							HStack {
								Image(systemName: "photo.on.rectangle")
								Text("Select a photo")
							}
							.foregroundColor(.uniPrimary)
						}
					}
				}
				
				Section("Details") {
					Picker("Post Type", selection: $viewModel.postType) {
						Text("Selling").tag(PostType.sell)
						Text("Requesting").tag(PostType.request)
					}
					.pickerStyle(.segmented)
					
					TextField("Title (e.g. Psychology Textbook)", text: $viewModel.title)
					TextField("Description", text: $viewModel.description, axis: .vertical)
						.lineLimit(3...5)
					
					if viewModel.postType == .sell {
						TextField("Price", text: $viewModel.priceString)
							.keyboardType(.decimalPad)
					}
				}
				
				Button {
					Task { await viewModel.uploadPost() }
				} label: {
					if viewModel.isLoading {
						ProgressView()
					} else {
						Text("Publish Post")
							.fontWeight(.bold)
					}
				}
				.frame(maxWidth: .infinity)
				.disabled(viewModel.title.isEmpty || viewModel.postImage == nil || viewModel.isLoading)
			}
			.navigationTitle("New Post")
			.navigationBarTitleDisplayMode(.inline)
			// --- iOS 16 COMPATIBLE ONCHANGE ---
			.onChange(of: viewModel.didUpload) { newValue in
				if newValue == true {
					dismiss()
				}
			}
			
			// ----------------------------------
		}
	}
}
