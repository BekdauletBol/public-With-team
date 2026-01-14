import SwiftUI

struct MainTabView: View {
	var body: some View {
		TabView {
			
			// TAB 1: MARKETPLACE
			FeedView()
				.tabItem {
					Image(systemName: "house")
					Text("Explore")
				}
			
			// TAB 2: SAVED ITEMS
			FavoritesView()
				.tabItem {
					Image(systemName: "heart.fill")
					Text("Favorites")
				}
			
			// TAB 3: CREATE POST
			UploadPostView()
				.tabItem {
					Image(systemName: "plus.circle.fill")
					Text("Submit")
				}
			
			// TAB 4: PROFILE
			ProfileView()
				.tabItem {
					Image(systemName: "person.fill")
					Text("Profile")
				}
		}
		.accentColor(.blue)
	}
}
