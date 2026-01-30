import SwiftUI
struct LoginView: View {
	@StateObject private var viewModel = LoginViewModel()
	
	var body: some View {
		NavigationStack {
			ZStack {
				Color.uniBackground.ignoresSafeArea()
				
				VStack(spacing: 32) {
					VStack(spacing: 8) {
						Text("public.")
							.font(.system(size: 42, weight: .bold, design: .rounded))
							.foregroundColor(.white)
						
						Text("context for your campus")
							.font(.system(.subheadline, design: .monospaced))
							.foregroundColor(.uniSecondaryText)
					}
					.padding(.top, 40)
					
					VStack(spacing: 16) {
						customTextField("Email", text: $viewModel.email, isSecure: false)
						customTextField("Password", text: $viewModel.password, isSecure: true)
					}
					.padding(.horizontal)
					
					VStack(spacing: 16) {
						Button {
							Task { await viewModel.login() }
						} label: {
							Group {
								if viewModel.isLoading {
									ProgressView().tint(.black)
								} else {
									Text("Login")
										.font(.system(.body, design: .monospaced))
										.fontWeight(.bold)
								}
							}
							.frame(maxWidth: .infinity)
							.padding(.vertical, 16)
							.background(Color.white)
							.foregroundColor(.black)
							.cornerRadius(4)
						}
						
						NavigationLink {
							RegistrationView()
						} label: {
							Text("Don't have an account? Sign Up")
								.font(.system(.footnote, design: .monospaced))
								.foregroundColor(.uniSecondaryText)
						}
					}
					.padding(.horizontal)
					
					Spacer()
				}
			}
			.alert("Error", isPresented: $viewModel.showAlert) {
				Button("OK", role: .cancel) { }
			} message: {
				Text(viewModel.errorMessage ?? "Unknown Error")
			}
		}
	}
	
	@ViewBuilder
	private func customTextField(_ placeholder: String, text: Binding<String>, isSecure: Bool) -> some View {
		Group {
			if isSecure {
				SecureField("", text: text, prompt: Text(placeholder).foregroundColor(.uniSecondaryText))
			} else {
				TextField("", text: text, prompt: Text(placeholder).foregroundColor(.uniSecondaryText))
			}
		}
		.padding()
		.background(Color.uniSurface)
		.overlay(
			RoundedRectangle(cornerRadius: 4)
				.stroke(Color.uniBorder, lineWidth: 1)
		)
		.foregroundColor(.white)
		.font(.system(.body, design: .monospaced))
		.textInputAutocapitalization(.never)
	}
}
