import SwiftUI
import Combine

@MainActor
class MyListingsViewModel: ObservableObject {
	@Published var myPosts = [Post]()
	@Published var isLoading = false
	
	func fetchMyPosts() async {
		isLoading = true
		do {
			self.myPosts = try await PostService.fetchMyPosts()
			print("DEBUG: Loaded \(myPosts.count) personal items.")
		} catch {
			print("DEBUG ERROR: \(error.localizedDescription)")
		}
		isLoading = false
	}
}

