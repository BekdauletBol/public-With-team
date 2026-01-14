import SwiftUI

struct OnboardingView: View {
	@State private var currentIndex = 0
	@State private var opacity = 0.0
	@State private var showButton = false
	
	private let storyWords = ["welcome.", "marketplace.", "community.", "public."]
	
	var body: some View {
		ZStack {
			// BACKGROUND COLOR
			
			Color("publicBackground")
				.ignoresSafeArea()
			
			VStack {
				Spacer()
				
				// FOREGROUND  COLOR
				Text(storyWords[currentIndex])
					.font(.system(size: 48, weight: .bold, design: .rounded))
					.foregroundColor(Color("publicTextColor"))
					.opacity(opacity)
					.id(currentIndex)
				
				Spacer()
				
				if showButton {
					Button {
						withAnimation {
							AuthService.shared.isNewRegistration = false
						}
					} label: {
						Text("get started")
							.font(.system(.title3, design: .rounded).bold())
							.frame(maxWidth: .infinity)
							.padding(.vertical, 16)
						
							// BUTTON COLORS
							.background(Color("publicTextColor"))
							.foregroundColor(Color("uniPrimary"))
							.cornerRadius(15)
							.padding(.horizontal, 40)
					}
					.transition(.move(edge: .bottom).combined(with: .opacity))
				}
			}
			.padding(.bottom, 50)
		}
		.onAppear { runStory() }
	}
	
	private func runStory() {
		withAnimation(.easeInOut(duration: 0.8)) { opacity = 1.0 }
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
			if currentIndex < storyWords.count - 1 {
				withAnimation(.easeInOut(duration: 0.8)) { opacity = 0.0 }
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
					currentIndex += 1
					runStory()
				}
			} else {
				withAnimation(.spring()) { showButton = true }
			}
		}
	}
}
