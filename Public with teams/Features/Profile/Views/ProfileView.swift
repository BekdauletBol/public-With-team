import SwiftUI
import PhotosUI

struct ProfileView: View {
	@StateObject private var viewModel = ProfileViewModel()
	@State private var showEditProfile = false
	@State private var selectedItem: PhotosPickerItem?
	
	var body: some View {
		NavigationStack {
			ZStack {
				Color.uniBackground.ignoresSafeArea()
				
				ScrollView {
					VStack(spacing: 32) {
						// 1. Header (Square Avatar + Stats)
						HStack(spacing: 20) {
							PhotosPicker(selection: $selectedItem, matching: .images) {
								avatarImage
							}
							
							VStack(alignment: .leading, spacing: 4) {
								Text(viewModel.student?.fullName ?? "user_loading")
									.font(.system(size: 22, weight: .bold, design: .rounded))
									.foregroundColor(.white)
								
								Text("@\(viewModel.student?.telegram_handle ?? "none")")
									.font(.system(.caption, design: .monospaced))
									.foregroundColor(.uniSecondaryText)
								
								Text(viewModel.student?.university ?? "No University")
									.font(.system(.caption2))
									.padding(.horizontal, 6)
									.padding(.vertical, 2)
									.background(Color.white.opacity(0.1))
									.foregroundColor(.white)
									.cornerRadius(2)
							}
							Spacer()
						}
						.padding(.horizontal)
						.padding(.top, 20)
						
						// 2. Navigation Actions
						VStack(spacing: 1) { // Сетка
							NavigationLink {
								MyListingsView()
							} label: {
								ProfileMenuRow(icon: "folder", title: "MY_POSTS", value: "Manage active items")
							}
							
							ProfileMenuRow(icon: "shield", title: "PRIVACY", value: "Contact visibility", hasToggle: true, toggleValue: Binding(
								get: { viewModel.student?.show_contact_info ?? true },
								set: { nv in Task { try? await AuthService.shared.updateContactVisibility(isVisible: nv) } }
							))
						}
						.background(Color.uniBorder)
						.border(Color.uniBorder, width: 1)
						.padding(.horizontal)

						// 3. Destructive Actions
						VStack(spacing: 12) {
							Button { showEditProfile.toggle() } label: {
								Text("EDIT_PROFILE")
									.font(.system(.caption, design: .monospaced))
									.frame(maxWidth: .infinity)
									.padding(.vertical, 12)
									.overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.uniBorder, lineWidth: 1))
									.foregroundColor(.white)
							}
							
							Button(role: .destructive) { viewModel.signOut() } label: {
								Text("TERMINATE_SESSION")
									.font(.system(.caption, design: .monospaced))
									.foregroundColor(.red)
									.frame(maxWidth: .infinity)
							}
						}
						.padding(.horizontal)
					}
				}
			}
			.navigationTitle("SYSTEM_PROFILE")
			.navigationBarTitleDisplayMode(.inline)
			.sheet(isPresented: $showEditProfile) { EditProfileView(viewModel: viewModel) }
		}
	}
	
	var avatarImage: some View {
		Group {
			if let avatarUrl = viewModel.student?.avatar_url, let url = URL(string: avatarUrl) {
				AsyncImage(url: url) { $0.resizable().scaledToFill() } placeholder: { ProgressView() }
			} else {
				Color.uniSurface.overlay(Text("ID").font(.system(.headline, design: .monospaced)).foregroundColor(.uniSecondaryText))
			}
		}
		.frame(width: 80, height: 80)
		.cornerRadius(4)
		.overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.uniBorder, lineWidth: 1))
	}
}

struct ProfileMenuRow: View {
	let icon: String
	let title: String
	let value: String
	var hasToggle: Bool = false
	var toggleValue: Binding<Bool>? = nil
	
	var body: some View {
		HStack(spacing: 16) {
			Image(systemName: icon)
				.font(.system(size: 18))
				.foregroundColor(.white)
				.frame(width: 24)
			
			VStack(alignment: .leading, spacing: 2) {
				Text(title)
					.font(.system(size: 10, design: .monospaced))
					.foregroundColor(.uniSecondaryText)
				Text(value)
					.font(.system(size: 14))
					.foregroundColor(.white)
			}
			
			Spacer()
			
			if hasToggle, let isOn = toggleValue {
				Toggle("", isOn: isOn).labelsHidden()
			} else {
				Image(systemName: "chevron.right")
					.font(.caption2)
					.foregroundColor(.uniBorder)
			}
		}
		.padding()
		.background(Color.uniBackground)
	}
}
