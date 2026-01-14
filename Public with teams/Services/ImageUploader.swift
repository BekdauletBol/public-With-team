import UIKit
import Supabase

struct ImageUploader {
	private static let client = SupabaseConfig.client

	static func uploadImage(image: UIImage) async throws -> String? {
		// 1. Compress image
		guard let data = image.jpegData(compressionQuality: 0.25) else { return nil }
		
		// 2. Create unique filename
		let fileName = "\(UUID().uuidString).jpg"
		
		// 3. Upload to 'post_images' bucket
		// Note: Using the new non-deprecated 'upload' syntax
		try await client.storage
			.from("post_images")
			.upload(
				
				fileName,
				data: data,
				options: FileOptions(contentType: "image/jpeg")
			)
			
		// 4. Get the Public URL (Added 'try' here to fix your red error)
		let url = try client.storage
			.from("post_images")
			.getPublicURL(path: fileName)
			
		return url.absoluteString
	}
}
