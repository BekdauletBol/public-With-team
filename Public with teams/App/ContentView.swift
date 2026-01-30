import SwiftUI
import Supabase

struct ContentView: View {
	@AppStorage("hasSeenHello") var hasSeenHello: Bool = false
		
	@ObservedObject private var authService = AuthService.shared
	
	@State private var isAuthenticated = false
	
	var body: some View {
		ZStack {
			Color("AppBackground")
				.ignoresSafeArea()
			
			Group {
				// --- THE LOGIC LADDER ---
				
				if !hasSeenHello {
					HelloView()
				}
				else if authService.isNewRegistration {
					OnboardingView()
				}
				else if isAuthenticated {
					MainTabView()
				}
				else {
					LoginView()
				}
			}
		}

		.preferredColorScheme(.dark)
		.task {
			await checkSession()
			for await _ in SupabaseConfig.client.auth.authStateChanges {
				await checkSession()
			}
		}
	}
	
	@MainActor
	private func checkSession() async {
		let session = try? await SupabaseConfig.client.auth.session
		self.isAuthenticated = (session != nil)
		
		if isAuthenticated {
			try? await authService.fetchCurrentUser()
		}
	}
}
