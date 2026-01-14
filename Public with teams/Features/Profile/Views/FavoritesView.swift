import SwiftUI

struct FavoritesView: View {
	@StateObject var viewModel = FavoritesViewModel()
	
	var body: some View {
		NavigationStack {
			ScrollView {
				LazyVStack(spacing: 16) {
					if viewModel.isLoading && viewModel.favoritePosts.isEmpty {
						ProgressView()
							.padding(.top, 50)
					} else if viewModel.favoritePosts.isEmpty {
						
						// --- iOS 16 COMPATIBLE EMPTY STATE ---
						VStack(spacing: 16) {
							Image(systemName: "heart.slash")
								.font(.system(size: 64))
								.foregroundColor(.secondary)
							
							Text("No Favorites")
								.font(.title2.bold())
							
							Text("Double-tap photos in the feed to save them here.")
								.font(.subheadline)
								.foregroundColor(.secondary)
								.multilineTextAlignment(.center)
						}
						.padding(.horizontal, 32)
						.padding(.top, 100)
						// --------------------------------------
					} else {
						ForEach(viewModel.favoritePosts) { post in
							VStack(spacing: 8) {
								// Display the post
								PostCard(post: post) {
									// Refresh the list if deleted from the card
									Task { await viewModel.fetchFavorites() }
								}
								
								// iOS 16 Compatible Remove Button
								Button(role: .destructive) {
									Task {
										try? await PostService.unfavoritePost(postId: post.id)
										await viewModel.fetchFavorites()
									}
								} label: {
									Label("Remove from Favorites", systemImage: "heart.slash")
										.font(.subheadline.bold())
								}
								.padding(.bottom, 12)
								
								Divider()
							}
						}
					}
				}
				.padding()
			}
			.navigationTitle("Favorites")
			.task {
				await viewModel.fetchFavorites()
			}
			.refreshable {
				await viewModel.fetchFavorites()
			}
		}
	}
}
