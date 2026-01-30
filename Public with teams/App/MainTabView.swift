import SwiftUI

struct MainTabView: View {
	
	init() {
		let appearance = UITabBarAppearance()
		appearance.configureWithOpaqueBackground()
		appearance.backgroundColor = UIColor(Color.uniBackground)
		
		appearance.shadowColor = UIColor(Color.uniBorder)
		
		let itemAppearance = UITabBarItemAppearance()
		itemAppearance.normal.iconColor = UIColor(Color.uniSecondaryText)
		itemAppearance.normal.titleTextAttributes = [
			.font: UIFont.monospacedSystemFont(ofSize: 10, weight: .medium),
			.foregroundColor: UIColor(Color.uniSecondaryText)
		]
		
		itemAppearance.selected.iconColor = .white
		itemAppearance.selected.titleTextAttributes = [
			.font: UIFont.monospacedSystemFont(ofSize: 10, weight: .bold),
			.foregroundColor: UIColor.white
		]
		
		appearance.stackedLayoutAppearance = itemAppearance
		appearance.inlineLayoutAppearance = itemAppearance
		appearance.compactInlineLayoutAppearance = itemAppearance
		
		UITabBar.appearance().standardAppearance = appearance
		if #available(iOS 15.0, *) {
			UITabBar.appearance().scrollEdgeAppearance = appearance
		}
	}

	var body: some View {
		TabView {
			FeedView()
				.tabItem {
					Label("Explore", systemImage: "terminal")
				}
			
			FavoritesView()
				.tabItem {
					Label("Saved", systemImage: "bookmark")
				}
			
			UploadPostView()
				.tabItem {
					Label("Submit", systemImage: "plus.square")
				}
			
			ProfileView()
				.tabItem {
					Label("User", systemImage: "command")
				}
		}
		.accentColor(.white)
	}
}
