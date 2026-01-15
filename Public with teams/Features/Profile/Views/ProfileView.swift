import SwiftUI
import PhotosUI

struct ProfileView: View {
	@StateObject private var viewModel = ProfileViewModel()
	@State private var showEditProfile = false
	@State private var selectedItem: PhotosPickerItem?
	
	var body: some View {
		NavigationStack {
			ZStack {
				Color(.systemGroupedBackground).ignoresSafeArea()
				
				ScrollView {
					VStack(spacing: 24) {
						// 1. Header (Avatar + Name)
						VStack(spacing: 12) {
							let studentAvatarUrl = viewModel.student?.avatar_url
							
							PhotosPicker(selection: $selectedItem, matching: .images) {
								if let avatarUrl = studentAvatarUrl, let url = URL(string: avatarUrl) {
									AsyncImage(url: url) { image in
										image.resizable().scaledToFill()
									} placeholder: {
										ProgressView()
									}
									.frame(width: 100, height: 100)
									.clipShape(Circle())
									.overlay(Circle().stroke(Color.white, lineWidth: 2))
									.shadow(radius: 3)
								} else {
									ZStack {
										Circle().fill(Color(red: 1.0, green: 0.9, blue: 0.8))
										Text("👻").font(.system(size: 60))
									}
									.frame(width: 100, height: 100)
								}
							}
							.padding(.top, 20)
							.onChange(of: selectedItem) { newItem in
								Task {
									if let data = try? await newItem?.loadTransferable(type: Data.self),
									   let uiImage = UIImage(data: data) {
										try? await AuthService.shared.uploadAvatar(image: uiImage)
									}
								}
							}
							
							Text(viewModel.student?.fullName.lowercased() ?? "loading...")
								.font(.system(size: 28, weight: .semibold, design: .rounded))
							
							Text("\(viewModel.student?.phone_number ?? "") • @\(viewModel.student?.telegram_handle ?? "no_handle")")
								.font(.subheadline)
								.foregroundColor(.secondary)
						}
						
						// 2. Main Edit Button
						Button {
							showEditProfile.toggle()
						} label: {
							HStack {
								Image(systemName: "pencil.line")
								Text("Edit Profile Settings")
							}
							.fontWeight(.semibold)
							.frame(maxWidth: .infinity)
							.padding(.vertical, 14)
							.background(Color.uniPrimary)
							.foregroundColor(.white)
							.clipShape(Capsule())
							.padding(.horizontal, 32)
						}
						
						// 3. Settings List
						VStack(spacing: 0) {
							NavigationLink {
								MyListingsView()
							} label: {
								ProfileMenuRow(icon: "tag.fill", color: .green, title: "my items.", value: "Manage your active posts", showChevron: true)
							}
							.buttonStyle(.plain)
							
							Divider().padding(.leading, 50)
							
							ProfileMenuRow(icon: "graduationcap.fill", color: .blue, title: "University", value: viewModel.student?.university ?? "---", showChevron: false)
							Divider().padding(.leading, 50)
							ProfileMenuRow(icon: "person.2.fill", color: .purple, title: "Group", value: viewModel.student?.class_group ?? "---", showChevron: false)
							Divider().padding(.leading, 50)
							ProfileMenuRow(icon: "envelope.fill", color: .orange, title: "Email", value: viewModel.student?.email ?? "---", showChevron: false)
						}
						.background(Color(.secondarySystemGroupedBackground))
						.cornerRadius(12)
						.padding(.horizontal)
						
						
						// 4. Sign Out Button
						Button(role: .destructive) {
							viewModel.signOut()
						} label: {
							Text("Sign Out")
								.fontWeight(.semibold)
								.foregroundColor(.red)
								.frame(maxWidth: .infinity)
								.padding(.vertical, 14)
								.background(Color(.secondarySystemGroupedBackground))
								.cornerRadius(12)
						}
						.padding(.horizontal)
					}
					.padding(.bottom, 30)
				}
			}
			.navigationTitle("settings.")
			.navigationBarTitleDisplayMode(.inline)
			.sheet(isPresented: $showEditProfile) {
				EditProfileView(viewModel: viewModel)
			}
		}
	}
}
struct ProfileMenuRow: View {
	let icon: String
	let color: Color
	let title: String
	let value: String
	let showChevron: Bool
	
	var body: some View {
		HStack(spacing: 16) {
			Image(systemName: icon)
				.foregroundColor(.white)
				.frame(width: 30, height: 30)
				.background(RoundedRectangle(cornerRadius: 8).fill(color))
			
			VStack(alignment: .leading) {
				Text(title)
					.font(.footnote)
					.foregroundColor(.secondary)
				Text(value)
					.font(.body)
					.foregroundColor(.primary)
			}
			Spacer()
			
			if showChevron {
				Image(systemName: "chevron.right")
					.font(.footnote)
					.foregroundColor(.secondary)
			}
		}
		.padding(.vertical, 10)
		.padding(.horizontal)
	}
}
