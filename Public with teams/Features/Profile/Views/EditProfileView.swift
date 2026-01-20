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
	
	@State private var isEmailVisible = true
	@State private var showContactInfo = true
	
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
				
				// --- BOTH TOGGLES ---
				Section("Privacy Settings") {
					Toggle("Show email to others", isOn: $isEmailVisible)
					Toggle("Show phone/telegram on posts", isOn: $showContactInfo)
				}
				.tint(.blue)
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
								isEmailVisible: isEmailVisible,
								
								showContactInfo: showContactInfo
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
					 showContactInfo = student.show_contact_info 
				 }
			 }
		 }
	 }
 }
