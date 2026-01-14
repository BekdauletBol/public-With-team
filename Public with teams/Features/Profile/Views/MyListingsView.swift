import SwiftUI

struct MyListingsView: View {
	@StateObject private var viewModel = MyListingsViewModel()
	
	var body: some View {
		ScrollView {
			
			LazyVStack(spacing: 16) {
				if viewModel.isLoading && viewModel.myPosts.isEmpty {
					ProgressView("loading your items...")
						.padding(.top, 50)
				} else if viewModel.myPosts.isEmpty {
					VStack(spacing: 16) {
						Image(systemName: "bag.badge.plus")
							.font(.system(size: 64))
							.foregroundColor(.secondary)
						Text("no items posted.").font(.title2.bold())
						Text("items you list for sale will appear here.").foregroundColor(.secondary)
					}
					.padding(.top, 100)
				} else {
					ForEach(viewModel.myPosts) { post in
						// Using our existing PostCard
						PostCard(post: post) {
							// After deletion, refresh the list
							Task { await viewModel.fetchMyPosts() }
						}
					}
				}
			}
			.padding()
		}
		.navigationTitle("my items.")
		.navigationBarTitleDisplayMode(.inline)
		.onAppear {
			Task { await viewModel.fetchMyPosts() }
		}
		.refreshable {
			await viewModel.fetchMyPosts()
		}
	}
}


