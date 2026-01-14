import SwiftUI

struct HelloView: View {
	@AppStorage("hasSeenHello") var hasSeenHello: Bool = false
	
	@State private var currentIndex = 0
	@State private var opacity = 0.0
	
	private let greetings = ["salem.","hello.", "bonjour.", "privet.", "hola.", "public."]
	
	var body: some View {
		
		ZStack {
			Color("publicBackground")
				.ignoresSafeArea()
			
			Text(greetings[currentIndex])
				.font(.system(size: 48, weight: .bold, design: .rounded))
				.foregroundColor(Color("publicTextColor"))
				.opacity(opacity)
		}
		.onAppear {
			runAnimationSequence()
		}
	}
	
	private func runAnimationSequence() {
		// 1. Fade In
		withAnimation(.easeIn(duration: 0.6)) {
			opacity = 1.0
		}
		
		// 2. Wait, then Fade Out
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
			withAnimation(.easeOut(duration: 0.6)) {
				opacity = 0.0
			}
			
			// 3. Change word and repeat
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
				if currentIndex < greetings.count - 1 {
					currentIndex += 1
					runAnimationSequence() // Loop to next word
				} else {
					// 4. END: Final transition to Login/Feed
					withAnimation {
						hasSeenHello = true
					}
				}
			}
		}
	}
}
