import Foundation
import Supabase

enum SupabaseConfig {
	static let client = SupabaseClient(
		supabaseURL: URL(string: "https://nwhanelhuxxevunwvggr.supabase.co")!,
		supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im53aGFuZWxodXh4ZXZ1bnd2Z2dyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njc0NjY3ODgsImV4cCI6MjA4MzA0Mjc4OH0.5WG3iERJFdl_XcIG3vjF5mPRAYheSecHsg2I7QbCiDk"
	)
}

