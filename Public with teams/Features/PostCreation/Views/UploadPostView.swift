import SwiftUI
import PhotosUI

struct UploadPostView: View {
	@StateObject private var viewModel = UploadPostViewModel()
	@Environment(\.dismiss) var dismiss
	
	var body: some View {
		NavigationStack {
			ZStack {
				Color.uniBackground.ignoresSafeArea()
				
				ScrollView {
					VStack(spacing: 24) {
						// Image Picker Section
						PhotosPicker(selection: $viewModel.selectedItem, matching: .images) {
							if let currentImage = viewModel.postImage {
								Image(uiImage: currentImage)
									.resizable()
									.scaledToFill()
									.frame(height: 250)
									.frame(maxWidth: .infinity)
									.cornerRadius(4)
									.overlay(
										RoundedRectangle(cornerRadius: 4)
											.stroke(Color.uniBorder, lineWidth: 1)
									)
									.clipped()
							} else {
								VStack(spacing: 12) {
									Image(systemName: "plus.viewfinder")
										.font(.largeTitle)
									Text("ATTACH_MEDIA")
										.font(.system(.caption, design: .monospaced))
								}
								.foregroundColor(.uniSecondaryText)
								.frame(height: 200)
								.frame(maxWidth: .infinity)
								.background(Color.uniSurface)
								.overlay(
									RoundedRectangle(cornerRadius: 4)
										.stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
										.foregroundColor(.uniBorder)
								)
							}
						}
						
						VStack(spacing: 16) {
							// Custom Segmented Picker
							HStack(spacing: 0) {
								ForEach([PostType.sell, PostType.request], id: \.self) { type in
									Button { viewModel.postType = type } label: {
										Text(type == .sell ? "SELL" : "REQUEST")
											.font(.system(.caption, design: .monospaced))
											.fontWeight(.bold)
											.frame(maxWidth: .infinity)
											.padding(.vertical, 10)
											.background(viewModel.postType == type ? Color.white : Color.clear)
											.foregroundColor(viewModel.postType == type ? .black : .uniSecondaryText)
									}
								}
							}
							.background(Color.uniSurface)
							.cornerRadius(4)
							.overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.uniBorder, lineWidth: 1))
							
							// Input Fields
							customTextField("TITLE", text: $viewModel.title)
							customTextField("DESCRIPTION", text: $viewModel.description, isMultiline: true)
							
							if viewModel.postType == .sell {
								customTextField("PRICE", text: $viewModel.priceString)
									.keyboardType(.decimalPad)
							}
						}
						
						// Action Button
						Button {
							Task { await viewModel.uploadPost() }
						} label: {
							Group {
								if viewModel.isLoading {
									ProgressView().tint(.black)
								} else {
									Text("PUBLISH_TO_NETWORK")
										.font(.system(.body, design: .monospaced))
										.fontWeight(.bold)
								}
							}
							.frame(maxWidth: .infinity)
							.padding(.vertical, 16)
							.background(viewModel.title.isEmpty ? Color.uniSurface : Color.white)
							.foregroundColor(viewModel.title.isEmpty ? .uniSecondaryText : .black)
							.cornerRadius(4)
						}
						.disabled(viewModel.title.isEmpty || viewModel.isLoading)
					}
					.padding()
				}
			}
			.navigationTitle("SUBMIT_POST")
			.navigationBarTitleDisplayMode(.inline)
			.onChange(of: viewModel.didUpload) { newValue in
				if newValue == true { dismiss() }
			}
		}
	}
	
	@ViewBuilder
	private func customTextField(_ placeholder: String, text: Binding<String>, isMultiline: Bool = false) -> some View {
		VStack(alignment: .leading, spacing: 4) {
			Text(placeholder)
				.font(.system(size: 10, design: .monospaced))
				.foregroundColor(.uniSecondaryText)
			
			Group {
				if isMultiline {
					TextEditor(text: text)
						.frame(minHeight: 100)
						.scrollContentBackground(.hidden)
				} else {
					TextField("", text: text)
				}
			}
			.padding(12)
			.background(Color.uniSurface)
			.foregroundColor(.white)
			.font(.system(.body, design: .monospaced))
			.overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.uniBorder, lineWidth: 1))
		}
	}
}
