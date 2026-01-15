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
	
	
	func registerUser(email: String, password: String, firstName: String, lastName: String, university: String, group: String, phoneNumber: String, telegramHandle: String) async throws {
		let response = try await client.auth.signUp(email: email, password: password)
		let userId = response.user.id
		
		// This matches the order and names in your Student struct
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
			is_email_visible: true
		)
		
		try await client.from("profiles").insert(student).execute()
		
		self.currentUser = student
		self.isNewRegistration = true
	}

	func updateUserInfo(firstName: String, lastName: String, university: String, group: String, phone: String, telegram: String, isEmailVisible: Bool) async throws {
		guard let uid = currentUser?.id else { return }

		// Define a temporary Encodable struct to match the database columns
		struct ProfileUpdate: Encodable {
			let first_name: String
			let last_name: String
			let university: String
			let class_group: String
			let phone_number: String
			let telegram_handle: String
			let is_email_visible: Bool
		}

		//Create the update object
		let update = ProfileUpdate(
			first_name: firstName,
			last_name: lastName,
			university: university,
			class_group: group,
			phone_number: phone,
			telegram_handle: telegram,
			is_email_visible: isEmailVisible
		)
		
		//  Send the struct to Supabase (Swift can now encode this perfectly!)
		try await client.from("profiles")
			.update(update)
			.eq("id", value: uid)
			.execute()
		
		// Refresh local user data
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
	// -> Toggle which work with visible our email
	func updateEmailVisibility(isVisible: Bool) async throws {
		guard let uid = currentUser?.id else { return }
		
		try await client.from("profiles")
			.update(["is_email_visible": isVisible])
			.eq("id", value: uid)
			.execute()
		
		// Refresh the local user so the UI stays in sync
		try await fetchCurrentUser()
	}
}
