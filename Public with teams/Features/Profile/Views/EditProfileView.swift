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
	
	
	var body: some View {
		NavigationStack {
			Form {
				Section("Personal Details") {
					TextField("First Name", text: $firstName)
					TextField("Last Name", text: $lastName)
				}
				
				Section("University") {
					TextField("University", text: $university)
					TextField("Group", text: $group)
				}
				
				Section("Contact Info") {
					TextField("Phone", text: $phone)
					TextField("Telegram Handle", text: $telegram)
				}
			}
			.navigationTitle("Edit Profile")
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
								telegram: telegram
							)
							dismiss()
						}
					}
					.fontWeight(.bold)
				}
			}
			.onAppear {
				// Pre-fill existing data
				if let student = viewModel.student {
					firstName = student.first_name
					lastName = student.last_name
					university = student.university
					group = student.class_group
					phone = student.phone_number
					telegram = student.telegram_handle ?? ""
				}
			}
		}
	}
}
