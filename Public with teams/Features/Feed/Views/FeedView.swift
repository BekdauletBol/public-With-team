import SwiftUI
import Supabase
import Combine

struct FeedView: View {
	@StateObject var viewModel = FeedViewModel()
	
	var body: some View {
		NavigationStack {
			ScrollView {
				
				LazyVStack(spacing: 16) {
					if viewModel.isLoading && viewModel.posts.isEmpty {
						ProgressView("Searching...")
							.padding(.top, 50)
					} else if viewModel.filteredPosts.isEmpty {
						VStack(spacing: 16) {
							Image(systemName: "magnifyingglass")
								.font(.system(size: 64))
								.foregroundColor(.secondary)
							
							Text("No results for \"\(viewModel.searchText)\"")
								.font(.title2.bold())
							
							Text("Check the spelling or try a different keyword.")
								.font(.subheadline)
								.foregroundColor(.secondary)
								.multilineTextAlignment(.center)
						}
						.padding(.horizontal, 32)
						.padding(.top, 100)
						// --------------------------------------
					} else {
						ForEach(viewModel.filteredPosts) { post in
							PostCard(post: post) {
								Task {
									await viewModel.fetchPosts()
								}
							}
						}
					}
				}
				.padding()
			}
			.navigationTitle("public.")
			.searchable(text: $viewModel.searchText, prompt: "Search for books, electronics...")
			.refreshable {
				await viewModel.fetchPosts()
			}
			.task {
				await viewModel.fetchPosts()
			}
		}
	}
}
