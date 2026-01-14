//
//  PostDetailView.swift
//  UniSwap
//
//  Created by Bekdaulet bolatov on 04.01.2026.
//

import SwiftUI


struct PostDetailView: View {
	let post: Post
	@Environment(\.dismiss) var dismiss
	
	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 20) {
				// 1. Large Image
				if let imageUrl = post.imageUrl, let url = URL(string: imageUrl) {
					AsyncImage(url: url) { image in
						image.resizable().scaledToFill()
					} placeholder: {
						Rectangle().fill(Color.gray.opacity(0.1))
					}
					.frame(maxWidth: .infinity)
					.frame(height: 350)
					.clipped()
				}
				
				VStack(alignment: .leading, spacing: 12) {
					// 2. Title & Badge
					HStack {
						Text(post.title).font(.largeTitle.bold())
						Spacer()
						Text(post.type == .sell ? "SELL" : "REQUEST")
							.font(.caption.bold()).padding(6)
							.background(Color.blue.opacity(0.1)).foregroundColor(.blue).cornerRadius(8)
					}
					
					// 3. Price
					Text(post.formattedPrice)
						.font(.title2.bold())
						.foregroundColor(.uniPrimary)
					
					Divider()
					
					// 4. Description
					Text("Description").font(.headline)
					Text(post.description).font(.body).foregroundColor(.secondary)
					
					Spacer(minLength: 40)
					
					// 5. Contact Section
					Text("Contact Seller").font(.headline)
					HStack(spacing: 15) {
						if let phone = post.phoneNumber {
							contactButton(title: "WhatsApp", color: .green, url: "https://wa.me/\(phone)")
						}
						if let tg = post.telegramHandle {
							contactButton(title: "Telegram", color: .blue, url: "https://t.me/\(tg)")
						}
					}
				}
				.padding()
			}
		}
		.ignoresSafeArea(edges: .top)
	}
	
	private func contactButton(title: String, color: Color, url: String) -> some View {
		Button {
			if let link = URL(string: url) { UIApplication.shared.open(link) }
		} label: {
			Text(title).fontWeight(.bold).frame(maxWidth: .infinity).padding().background(color).foregroundColor(.white).cornerRadius(12)
		}
	}
}
