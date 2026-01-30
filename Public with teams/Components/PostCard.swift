import SwiftUI

struct PostCard: View {
	let post: Post
	var onDelete: (() -> Void)? = nil
	
	@State private var isLiked = false
	@State private var showDeleteConfirmation = false
	@State private var animateHeart = false
	
	var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			// Image Section
			ZStack(alignment: .topTrailing) {
				if let imageUrl = post.imageUrl, let url = URL(string: imageUrl) {
					AsyncImage(url: url) { image in
						image.resizable()
							.scaledToFill()
							.frame(height: 220)
					} placeholder: {
						Rectangle()
							.fill(Color.uniSurface)
							.frame(height: 220)
							.overlay(ProgressView().tint(.white))
					}
					.clipped()
					.onTapGesture(count: 2) { handleLike() }
				}

				// Тип объявления (Sell/Request) - в углу изображения
				Text(post.type == .sell ? "SELL" : "REQUEST")
					.font(.system(size: 10, weight: .bold, design: .monospaced))
					.padding(.horizontal, 8)
					.padding(.vertical, 4)
					.background(post.type == .sell ? Color.green : Color.blue)
					.foregroundColor(.black)
					.padding(12)
			}
			
			// Content Section
			VStack(alignment: .leading, spacing: 12) {
				HStack(alignment: .top) {
					VStack(alignment: .leading, spacing: 4) {
						Text(post.title)
							.font(.system(.headline, design: .rounded))
							.foregroundColor(.white)
						
						Text(post.description)
							.font(.system(.subheadline))
							.foregroundColor(.uniSecondaryText)
							.lineLimit(2)
					}
					
					Spacer()
					
					if String(post.ownerId).lowercased() == String(AuthService.shared.currentUser?.id ?? "").lowercased() {
						Button { showDeleteConfirmation = true } label: {
							Image(systemName: "xmark.square")
								.foregroundColor(.red)
								.font(.title3)
						}
					}
				}
				
				HStack {
					Text(post.formattedPrice)
						.font(.system(.title3, design: .monospaced))
						.fontWeight(.bold)
						.foregroundColor(.white)
					
					Spacer()
					
					if isLiked {
						Image(systemName: "heart.fill")
							.foregroundColor(.red)
							.font(.caption)
					}
				}
				
				// Contact Buttons - Тонкие рамки
				HStack(spacing: 8) {
					if let phone = post.phoneNumber, !phone.isEmpty {
						contactButton(title: "WhatsApp", icon: "message", url: "https://wa.me/\(phone.replacingOccurrences(of: "+", with: "").replacingOccurrences(of: " ", with: ""))")
					}
					
					if let telegram = post.telegramHandle, !telegram.isEmpty {
						contactButton(title: "Telegram", icon: "paperplane", url: "https://t.me/\(telegram.replacingOccurrences(of: "@", with: ""))")
					}
				}
				.padding(.top, 4)
			}
			.padding(16)
		}
		.background(Color.uniSurface)
		.cornerRadius(4) // Минимум скруглений
		.overlay(
			RoundedRectangle(cornerRadius: 4)
				.stroke(Color.uniBorder, lineWidth: 1)
		)
		.task { await checkIfLiked() }
	}
	
	private func contactButton(title: String, icon: String, url: String) -> some View {
		Button {
			if let link = URL(string: url) { UIApplication.shared.open(link) }
		} label: {
			HStack {
				Image(systemName: icon)
				Text(title).font(.system(size: 14, weight: .bold, design: .monospaced))
			}
			.frame(maxWidth: .infinity)
			.padding(.vertical, 10)
			.overlay(
				RoundedRectangle(cornerRadius: 2)
					.stroke(Color.uniBorder, lineWidth: 1)
			)
			.foregroundColor(.white)
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
