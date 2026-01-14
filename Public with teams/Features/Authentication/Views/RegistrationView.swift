import SwiftUI

struct RegistrationView: View {
	@StateObject private var viewModel = RegistrationViewModel()
	@Environment(\.dismiss) var dismiss
	
	var body: some View {
		VStack {
			Form {
				Section("Personal Details") {
					
					TextField("First Name", text: $viewModel.firstName)
					TextField("Last Name", text: $viewModel.lastName)
					TextField("University", text: $viewModel.university)
					TextField("Phone", text: $viewModel.phoneNumber)
						.keyboardType(.phonePad)
					
					// NEW: Telegram Handle Field
					TextField("Telegram Username (e.g.@eto1sm )", text: $viewModel.telegramHandle)
						.textInputAutocapitalization(.never)
						.autocorrectionDisabled()
				}
				
				Section("Credentials") {
					TextField("Email", text: $viewModel.email)
						.textInputAutocapitalization(.never)
						.keyboardType(.emailAddress)
						.autocorrectionDisabled()
					
					SecureField("Password", text: $viewModel.password)
				}
				
				Button {
					Task { await viewModel.register() }
				} label: {
					if viewModel.isLoading {
						ProgressView()
					} else {
						Text("Create Account").fontWeight(.bold)
					}
				}
				.frame(maxWidth: .infinity)
				.listRowBackground(Color.uniPrimary)
				.foregroundColor(.white)
			}
		}
		.navigationTitle("Join public.")
		.alert("Error", isPresented: $viewModel.showAlert) {
			Button("OK", role: .cancel) {}
		} message: {
			Text(viewModel.errorMessage ?? "")
		}
	}
}
