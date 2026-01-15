import Foundation

struct Student: Codable, Identifiable, Hashable, Sendable {
	let id: String
	let first_name: String
	let last_name: String
	let university: String
	let class_group: String
	let phone_number: String
	let telegram_handle: String?
	let avatar_url: String? 
	let email: String
	
	let is_email_visible: Bool
	
	
	var fullName: String { "\(first_name) \(last_name)" }
}

