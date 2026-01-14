import SwiftUI
import Combine

@MainActor
class ProfileViewModel: ObservableObject {
	@Published var student: Student?
	
	init() {
		Task { await fetchStudentData() }
	}
	
	func fetchStudentData() async {
		do {
			try await AuthService.shared.fetchCurrentUser()
			self.student = AuthService.shared.currentUser
		} catch {
			print("DEBUG: \(error)")
		}
	}
	
	
	func signOut() {
		Task {
			await AuthService.shared.signOut()
		}
	}
}
