import SwiftUI
import Supabase
import Combine

struct FeedView: View {
	@StateObject var viewModel = FeedViewModel()
	
	init() {
		let appearance = UINavigationBarAppearance()
		appearance.configureWithTransparentBackground()
		appearance.backgroundColor = .clear
		appearance.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.monospacedSystemFont(ofSize: 18, weight: .bold)]
		appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 34, weight: .bold)]
		
		UINavigationBar.appearance().standardAppearance = appearance
		UINavigationBar.appearance().scrollEdgeAppearance = appearance
	}
	
	var body: some View {
		NavigationStack {
			ZStack {
				Color.uniBackground.ignoresSafeArea()
				
				ScrollView {
					LazyVStack(spacing: 20) {
						if viewModel.isLoading && viewModel.posts.isEmpty {
							ProgressView()
								.tint(.white)
								.padding(.top, 50)
						} else if viewModel.filteredPosts.isEmpty {
							emptyStateView
						} else {
							ForEach(viewModel.filteredPosts) { post in
								PostCard(post: post) {
									Task { await viewModel.fetchPosts() }
								}
							}
						}
					}
					.padding()
				}
			}
			.navigationTitle("public.")
			.searchable(text: $viewModel.searchText, prompt: "Search...")
			.refreshable { await viewModel.fetchPosts() }
			.task { await viewModel.fetchPosts() }
		}
	}
	
	private var emptyStateView: some View {
		VStack(spacing: 16) {
			Image(systemName: "terminal")
				.font(.system(size: 48, weight: .light, design: .monospaced))
				.foregroundColor(.uniSecondaryText)
			
			Text("No results for \"\(viewModel.searchText)\"")
				.font(.system(.headline, design: .monospaced))
				.foregroundColor(.white)
			
			Text("Try a different keyword.")
				.font(.system(.subheadline, design: .monospaced))
				.foregroundColor(.uniSecondaryText)
		}
		.padding(.top, 100)
	}
}
