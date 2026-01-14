import SwiftUI
import Combine

@MainActor
class FavoritesViewModel: ObservableObject {
	@Published var favoritePosts = [Post]()
	@Published var isLoading = false
	
	func fetchFavorites() async {
		isLoading = true
		do {
			self.favoritePosts = try await PostService.fetchFavoritePosts()
			print("DEBUG: Successfully fetched \(favoritePosts.count) favorites")
		} catch {
			print("DEBUG: Error fetching favorites: \(error)")
		}
		isLoading = false
	}
	
}
