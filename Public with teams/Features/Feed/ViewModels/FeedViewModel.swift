import SwiftUI
import Supabase
import Combine

@MainActor
class FeedViewModel: ObservableObject {
	@Published var posts = [Post]()
	@Published var isLoading = false
	@Published var searchText = ""
	
	var filteredPosts: [Post] {
		if searchText.isEmpty {
			return posts
		} else {
			return posts.filter { post in
				post.title.lowercased().contains(searchText.lowercased()) ||
				post.description.lowercased().contains(searchText.lowercased())
			}
		}
	}
	
	
	func fetchPosts() async {
		isLoading = true
		do {
			let fetchedPosts: [Post] = try await SupabaseConfig.client
				.from("posts")
				.select()
				.order("created_at", ascending: false)
				.execute()
				.value
			
			self.posts = fetchedPosts
			print("DEBUG: Fetched \(fetchedPosts.count) posts")
		} catch {
			print("DEBUG: Error fetching posts: \(error)")
		}
		isLoading = false
	}
}
