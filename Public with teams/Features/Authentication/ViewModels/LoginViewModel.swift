import Foundation
import SwiftUI
import Combine

@MainActor
class LoginViewModel: ObservableObject {
	@Published var email = ""
	@Published var password = ""
	@Published var isLoading = false
	@Published var errorMessage: String?
	@Published var showAlert = false
	
	func login() async {
		
		guard !email.isEmpty, !password.isEmpty else { return }
		isLoading = true
		
		do {
			try await AuthService.shared.loginUser(email: email, password: password)
			isLoading = false
		} catch {
			self.errorMessage = error.localizedDescription
			self.showAlert = true
			self.isLoading = false
		}
	}
}
