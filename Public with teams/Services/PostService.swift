import Foundation
import Supabase

struct PostService: Sendable {
	private static let client = SupabaseConfig.client
	
	// 1. CREATE (CRUD)
	static func uploadPost(_ post: Post) async throws {
		try await client.from("posts").insert(post).execute()
	}
	
	// 2. READ (CRUD) - Fetch My Items only
	static func fetchMyPosts() async throws -> [Post] {
		guard let uid = AuthService.shared.currentUser?.id else { return [] }
		
		return try await client
			.from("posts")
			.select()
			.eq("owner_id", value: uid)
			.order("created_at", ascending: false)
			.execute()
			.value
	}
	
	// 3. DELETE (CRUD)
	static func deletePost(postId: String) async throws {
		try await client.from("posts").delete().eq("id", value: postId).execute()
	}

	// MARK: - Favorites Logic (Social Feature)

	static func favoritePost(postId: String) async throws {
		guard let uid = AuthService.shared.currentUser?.id else { return }
		try await client.from("favorites").insert(["user_id": uid, "post_id": postId]).execute()
	}

	static func unfavoritePost(postId: String) async throws {
		guard let uid = AuthService.shared.currentUser?.id else { return }
		try await client.from("favorites").delete().eq("user_id", value: uid).eq("post_id", value: postId).execute()
	}

	static func fetchFavoritePosts() async throws -> [Post] {
		guard let uid = AuthService.shared.currentUser?.id else { return [] }
		let response = try await client.from("favorites").select("posts(*)").eq("user_id", value: uid).execute()
		
		// Supabase returns nested JSON for joins, we must unwrap it
		struct Wrapper: Decodable { let posts: Post }
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601
		
		let rows = try decoder.decode([Wrapper].self, from: response.data)
		return rows.map { $0.posts }
	}
}
