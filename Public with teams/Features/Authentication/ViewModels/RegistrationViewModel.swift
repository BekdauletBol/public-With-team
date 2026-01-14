import SwiftUI
import Combine

@MainActor
class RegistrationViewModel: ObservableObject {
	
	@Published var email = ""
	@Published var password = ""
	@Published var firstName = ""
	
	@Published var lastName = ""
	@Published var university = ""
	@Published var group = ""
	@Published var phoneNumber = ""
	@Published var telegramHandle = "" // New property for Telegram
	
	// UI State
	@Published var isLoading = false
	@Published var errorMessage: String?
	@Published var showAlert = false
	
	/// Calls the AuthService to create a new user account.
	func register() async {
		// Basic validation
		let cleanedEmail = email.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
		
		// Remove @ if the user typed it, as t.me links don't need it
		let cleanedTelegram = telegramHandle.replacingOccurrences(of: "@", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
		
		guard !cleanedEmail.isEmpty, !password.isEmpty, !firstName.isEmpty else {
			self.errorMessage = "Please fill in all required fields."
			self.showAlert = true
			return
		}
		
		isLoading = true
		errorMessage = nil
		
		do {
			try await AuthService.shared.registerUser(
				email: cleanedEmail,
				password: password,
				firstName: firstName,
				lastName: lastName,
				university: university,
				group: group,
				phoneNumber: phoneNumber,
				telegramHandle: cleanedTelegram // Passing the new telegram handle
			)
			isLoading = false
		} catch {
			self.errorMessage = error.localizedDescription
			self.showAlert = true
			self.isLoading = false
		}
	}
}
