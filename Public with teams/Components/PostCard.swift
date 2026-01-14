import SwiftUI

struct PostCard: View {
	let post: Post
	var onDelete: (() -> Void)? = nil
	
	
	@State private var isLiked = false
	@State private var showDeleteConfirmation = false
	@State private var animateHeart = false 
	
	var body: some View {
		VStack(alignment: .leading, spacing: 12) {
			
			ZStack {
				if let imageUrl = post.imageUrl, let url = URL(string: imageUrl) {
					AsyncImage(url: url) { image in
						image.resizable()
							.scaledToFill()
							.frame(height: 250)
							.cornerRadius(12)
					} placeholder: {
						ProgressView().frame(height: 250).frame(maxWidth: .infinity)
					}
					.clipped()
					.contentShape(Rectangle())
					.onTapGesture(count: 2) {
						handleLike()
					}
				}
				
				// Animated Pop-up Heart
				Image(systemName: "heart.fill")
					.font(.system(size: 80))
					.foregroundColor(.red)
					.shadow(radius: 10)
					.scaleEffect(animateHeart ? 1.0 : 0)
					.opacity(animateHeart ? 1.0 : 0)
			}
			
			// Info Section
			VStack(alignment: .leading, spacing: 4) {
				HStack {
					Text(post.title).font(.headline)
					
					if isLiked {
						Image(systemName: "heart.fill")
							.foregroundColor(.red)
							.font(.caption)
					}
					
					Spacer()
					
					if String(post.ownerId).lowercased() == String(AuthService.shared.currentUser?.id ?? "").lowercased() {
						Button {
							print("DEBUG: Trash icon tapped for post: \(post.title)")
							showDeleteConfirmation = true
						} label: {
							Image(systemName: "trash")
								.foregroundColor(.red)
								.padding(8)
								.background(Color.red.opacity(0.1))
								.clipShape(Circle())
						}
						.buttonStyle(.plain)
					}
					
					Text(post.type == .sell ? "SELL" : "REQUEST")
						.font(.caption2).fontWeight(.bold).padding(5)
						.background(post.type == .sell ? Color.green.opacity(0.1) : Color.blue.opacity(0.1))
						.foregroundColor(post.type == .sell ? .green : .blue)
						.cornerRadius(6)
				}
				
				Text(post.description).font(.subheadline).foregroundColor(.secondary).lineLimit(2)
				Text(post.formattedPrice).font(.title3).fontWeight(.bold).foregroundColor(.primary)
			}
			
			//Contact Buttons
			VStack(spacing: 8) {
				if let phone = post.phoneNumber, !phone.isEmpty {
					contactButton(title: "WhatsApp", icon: "message.fill", color: .green, url: "https://wa.me/\(phone.replacingOccurrences(of: "+", with: "").replacingOccurrences(of: " ", with: ""))")
				}
				
				if let telegram = post.telegramHandle, !telegram.isEmpty {
					contactButton(title: "Telegram", icon: "paperplane.fill", color: .blue, url: "https://t.me/\(telegram.replacingOccurrences(of: "@", with: ""))")
				}
			}
		}
		.padding()
		.background(Color(.systemBackground))
		.cornerRadius(15)
		.shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
		.task { await checkIfLiked() }
		.confirmationDialog("Delete Post?", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
			Button("Delete", role: .destructive) {
				Task { try? await PostService.deletePost(postId: post.id); onDelete?() }
			}
		}
	}
	
	
	private func handleLike() {
		Task {
			withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
				animateHeart = true
			}
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
				withAnimation { animateHeart = false }
			}
			
			if !isLiked {
				try? await PostService.favoritePost(postId: post.id)
				isLiked = true
			}
		}
	}
	
	private func checkIfLiked() async {
		let favorites = try? await PostService.fetchFavoritePosts()
		self.isLiked = favorites?.contains(where: { $0.id == post.id }) ?? false
	}
	
	private func contactButton(title: String, icon: String, color: Color, url: String) -> some View {
		Button {
			if let link = URL(string: url) { UIApplication.shared.open(link) }
		} label: {
			HStack {
				Image(systemName: icon)
				Text("Contact via \(title)").fontWeight(.bold)
			}
			.frame(maxWidth: .infinity)
			.padding(.vertical, 12)
			.background(color)
			.foregroundColor(.white)
			.cornerRadius(12)
		}
	}
}
