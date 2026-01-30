import SwiftUI

import SwiftUI

struct FavoritesView: View {
	@StateObject private var viewModel = FavoritesViewModel()
	
	var body: some View {
		NavigationStack {
			ZStack {
				Color.uniBackground.ignoresSafeArea()
				
				ScrollView {
					VStack(alignment: .leading, spacing: 20) {
						
						VStack(alignment: .leading, spacing: 4) {
							Text("LOCAL_ARCHIVE")
								.font(.system(.caption, design: .monospaced))
								.foregroundColor(.uniSecondaryText)
							
							Text("Saved Items")
								.font(.system(size: 28, weight: .bold, design: .rounded))
								.foregroundColor(.white)
						}
						.padding(.horizontal)
						.padding(.top, 10)

						if viewModel.isLoading {
							ProgressView()
								.tint(.white)
								.frame(maxWidth: .infinity, minHeight: 200)
						} else if viewModel.favoritePosts.isEmpty {
							emptyState
						} else {
							LazyVStack(spacing: 16) {
								ForEach(viewModel.favoritePosts) { post in
									PostCard(post: post) {
										Task { await viewModel.fetchFavorites() }
									}
								}
							}
							.padding(.horizontal)
						}
					}
					.padding(.bottom, 20)
				}
			}
			.navigationBarTitleDisplayMode(.inline)
			.refreshable {
				await viewModel.fetchFavorites()
			}
			.task {
				await viewModel.fetchFavorites()
			}
		}
	}
	
	private var emptyState: some View {
		VStack(spacing: 20) {
			Spacer(minLength: 50)
			
			Image(systemName: "tray.and.arrow.down")
				.font(.system(size: 40, weight: .ultraLight))
				.foregroundColor(.uniBorder)
			
			VStack(spacing: 8) {
				Text("NO_SAVED_DATA")
					.font(.system(.subheadline, design: .monospaced))
					.foregroundColor(.white)
				
				Text("Double tap a post to save it to your local archive.")
					.font(.system(size: 13))
					.foregroundColor(.uniSecondaryText)
					.multilineTextAlignment(.center)
			}
			.padding(.horizontal, 40)
			
			Spacer()
		}
		.frame(maxWidth: .infinity)
	}
}
