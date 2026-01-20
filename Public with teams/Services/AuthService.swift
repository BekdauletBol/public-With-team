import SwiftUI
import Combine
import Supabase

@MainActor
final class AuthService: ObservableObject {
	static let shared = AuthService()
	private let client = SupabaseConfig.client
	
	@Published var currentUser: Student?
	@Published var isNewRegistration = false
	
	private init() {}
	
	// 1. Registration (Initializes both toggles to true)
	func registerUser(email: String, password: String, firstName: String, lastName: String, university: String, group: String, phoneNumber: String, telegramHandle: String) async throws {
		let response = try await client.auth.signUp(email: email, password: password)
		let userId = response.user.id
		
		let student = Student(
			id: userId.uuidString,
			first_name: firstName,
			last_name: lastName,
			university: university,
			class_group: group,
			phone_number: phoneNumber,
			telegram_handle: telegramHandle,
			avatar_url: nil,
			email: email,
			is_email_visible: true, // Default ON
			show_contact_info: true  // Default ON
		)
		
		try await client.from("profiles").insert(student).execute()
		
		self.currentUser = student
		self.isNewRegistration = true
	}

	// 2. Full Update (Used by the Edit Profile sheet)
	func updateUserInfo(firstName: String, lastName: String, university: String, group: String, phone: String, telegram: String, isEmailVisible: Bool, showContactInfo: Bool) async throws {
		guard let uid = currentUser?.id else { return }

		// Using a struct ensures we avoid the 'Any' encoding error
		struct ProfileUpdate: Encodable {
			let first_name, last_name, university, class_group, phone_number, telegram_handle: String
			let is_email_visible, show_contact_info: Bool
		}

		let update = ProfileUpdate(
			first_name: firstName, last_name: lastName, university: university,
			class_group: group, phone_number: phone, telegram_handle: telegram,
			is_email_visible: isEmailVisible,
			show_contact_info: showContactInfo
		)
		
		try await client.from("profiles").update(update).eq("id", value: uid).execute()
		try await fetchCurrentUser()
	}

	// 3. Email Toggle Update
	func updateEmailVisibility(isVisible: Bool) async throws {
		guard let uid = currentUser?.id else { return }
		try await client.from("profiles").update(["is_email_visible": isVisible]).eq("id", value: uid).execute()
		try await fetchCurrentUser()
	}
	
	// 4. Contact Toggle Update (WhatsApp/Telegram)
	func updateContactVisibility(isVisible: Bool) async throws {
		guard let uid = currentUser?.id else { return }
		try await client.from("profiles").update(["show_contact_info": isVisible]).eq("id", value: uid).execute()
		try await fetchCurrentUser()
	}

	func loginUser(email: String, password: String) async throws {
		try await client.auth.signIn(email: email, password: password)
		try await fetchCurrentUser()
		self.isNewRegistration = false
	}

	func fetchCurrentUser() async throws {
		guard let userId = try? await client.auth.session.user.id else { return }
		let student: Student = try await client.from("profiles").select().eq("id", value: userId).single().execute().value
		self.currentUser = student
	}
	
	func signOut() async {
		try? await client.auth.signOut()
		self.currentUser = nil
		self.isNewRegistration = false
	}
	
	func uploadAvatar(image: UIImage) async throws {
		guard let uid = currentUser?.id, let data = image.jpegData(compressionQuality: 0.2) else { return }
		let fileName = "avatar_\(uid).jpg"
		try await client.storage.from("avatars").upload(fileName, data: data, options: FileOptions(contentType: "image/jpeg", upsert: true))
		let url = try client.storage.from("avatars").getPublicURL(path: fileName)
		try await client.from("profiles").update(["avatar_url": url.absoluteString]).eq("id", value: uid).execute()
		try await fetchCurrentUser()
	}
}
