import SwiftUI
import Supabase

struct ContentView: View {
	// 1. Tracks the first-time-ever greeting sequence
	@AppStorage("hasSeenHello") var hasSeenHello: Bool = false
	
	// 2. We use @ObservedObject to watch the shared Auth Engine
	@ObservedObject private var authService = AuthService.shared
	
	// 3. Tracks the local Supabase session status
	@State private var isAuthenticated = false
	
	var body: some View {
		Group {
			// --- THE LOGIC LADDER ---
			
			if !hasSeenHello {
				// Step A: Multi-language splash (Only once ever)
				HelloView()
			}
			else if authService.isNewRegistration {
				// Step B: Cinematic Story (Only after clicking 'Create Account')
				OnboardingView()
			}
			else if isAuthenticated {
				// Step C: The Marketplace (Logged in normally)
				MainTabView()
			}
			else {
				// Step D: The Entrance (Not logged in)
				LoginView()
			}
		}
		.task {
			// Check session on startup
			await checkSession()
			
			// Listen for login/logout events
			for await _ in SupabaseConfig.client.auth.authStateChanges {
				await checkSession()
			}
		}
	}
	
	@MainActor
	private func checkSession() async {
		let session = try? await SupabaseConfig.client.auth.session
		self.isAuthenticated = (session != nil)
		
		// If logged in, ensure we have the user profile data
		if isAuthenticated {
			try? await authService.fetchCurrentUser()
		}
	}
}
