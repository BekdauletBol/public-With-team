import SwiftUI

struct LoginView: View {
	@StateObject private var viewModel = LoginViewModel()
	
	var body: some View {
		NavigationStack {
			VStack(spacing: 20) {
				Text("public.")
					.font(.largeTitle)
					.fontWeight(.black)
				
					.foregroundColor(.uniPrimary)
				
				VStack(spacing: 12) {
					TextField("Email", text: $viewModel.email)
						.padding()
						.background(Color(.systemGray6))
						.cornerRadius(10)
						.textInputAutocapitalization(.never)
					
					SecureField("Password", text: $viewModel.password)
						.padding()
						.background(Color(.systemGray6))
						.cornerRadius(10)
				}
				.padding(.horizontal)
				
				Button {
					Task { await viewModel.login() }
				} label: {
					if viewModel.isLoading {
						ProgressView()
							.tint(.white)
					} else {
						Text("Login")
							.fontWeight(.bold)
					}
				}
				.frame(maxWidth: .infinity)
				.padding()
				.background(Color.uniPrimary)
				.foregroundColor(.white)
				.cornerRadius(10)
				.padding(.horizontal)
				
				NavigationLink {
					RegistrationView()
				} label: {
					Text("Don't have an account? Sign Up")
						.font(.footnote)
				}
			}
			.alert("Error", isPresented: $viewModel.showAlert) {
				Button("OK", role: .cancel) { }
			} message: {
				Text(viewModel.errorMessage ?? "Unknown Error")
			}
		}
	}
}
