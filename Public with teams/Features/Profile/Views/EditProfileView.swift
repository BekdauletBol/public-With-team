import SwiftUI

struct EditProfileView: View {
	@ObservedObject var viewModel: ProfileViewModel
	@Environment(\.dismiss) var dismiss
	
	@State private var firstName = ""
	@State private var lastName = ""
	@State private var university = ""
	@State private var group = ""
	@State private var phone = ""
	@State private var telegram = ""
	
	// --- REQUIREMENT 1.1: STATE FOR THE TOGGLE ---
	@State private var isEmailVisible = true
	
	var body: some View {
		NavigationStack {
			Form {
				Section("Personal Details") {
					TextField("First Name", text: $firstName)
					TextField("Last Name", text: $lastName)
				}
				
				Section("Contact Info") {
					TextField("Phone", text: $phone)
					TextField("Telegram Handle", text: $telegram)
				}
				
				Section("Privacy settings.") {
					Toggle("Show my email to others", isOn: $isEmailVisible)
						.tint(.blue)
				}
			}
			.navigationTitle("edit profile.")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .topBarLeading) {
					Button("Cancel") { dismiss() }
				}
				ToolbarItem(placement: .topBarTrailing) {
					Button("Save") {
						Task {
							try? await AuthService.shared.updateUserInfo(
								firstName: firstName,
								lastName: lastName,
								university: university,
								group: group,
								phone: phone,
								telegram: telegram,
								isEmailVisible: isEmailVisible // FIXED
							)
							dismiss()
						}
					}
					.fontWeight(.bold)
				}
			}
			.onAppear {
				if let student = viewModel.student {
					firstName = student.first_name
					lastName = student.last_name
					university = student.university
					group = student.class_group
					phone = student.phone_number
					telegram = student.telegram_handle ?? ""
					isEmailVisible = student.is_email_visible 
				}
			}
		}
	}
}
