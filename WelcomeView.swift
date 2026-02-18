import SwiftUI

struct WelcomeView: View {
    
    @Binding var logs: [SessionLog]
    
    @State private var animate = false
    @State private var isPressed = false
    
    var body: some View {
        
        ZStack {
            
            // Animated Gradient Background
            LinearGradient(
                colors: [
                    Color(red: 0.20, green: 0.14, blue: 0.40),
                    Color(red: 0.35, green: 0.25, blue: 0.65)
                ],
                startPoint: animate ? .topLeading : .bottomTrailing,
                endPoint: animate ? .bottomTrailing : .topLeading
            )
            .ignoresSafeArea()
            .animation(
                .easeInOut(duration: 8).repeatForever(autoreverses: true),
                value: animate
            )
            
            VStack(spacing: 32) {
                
                Spacer()
                
                Text("Clarity Lab")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Color.white.opacity(0.7))
                    .tracking(2)
                    .opacity(animate ? 1 : 0)
                    .offset(y: animate ? 0 : 15)
                    .animation(.easeOut(duration: 0.8), value: animate)
                
                // Headline with glow
                ZStack {
                    Text("Find What Works.")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Find What Works.")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(Color.white.opacity(0.6))
                        .blur(radius: 12)
                        .opacity(0.6)
                }
                .opacity(animate ? 1 : 0)
                .offset(y: animate ? 0 : 25)
                .animation(.easeOut(duration: 1).delay(0.2), value: animate)
                
                Text("Run small experiments.\nMeasure real improvement.")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 16))
                    .foregroundColor(Color.white.opacity(0.75))
                    .opacity(animate ? 1 : 0)
                    .offset(y: animate ? 0 : 30)
                    .animation(.easeOut(duration: 1).delay(0.4), value: animate)
                
                Spacer()
                
                NavigationLink {
                    ChooseExperimentView(logs: $logs)
                } label: {
                    Text("Get Started")
                        .font(.system(size: 18, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(Color.white.opacity(0.12))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(Color.white.opacity(0.25), lineWidth: 1)
                        )
                        .foregroundColor(.white)
                        .scaleEffect(isPressed ? 0.97 : 1)
                        .animation(.easeOut(duration: 0.15), value: isPressed)
                }
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in isPressed = true }
                        .onEnded { _ in
                            isPressed = false
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }
                )
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
                .opacity(animate ? 1 : 0)
                .offset(y: animate ? 0 : 40)
                .animation(.easeOut(duration: 1).delay(0.6), value: animate)
            }
        }
        .onAppear {
            animate = true
        }
    }
}

