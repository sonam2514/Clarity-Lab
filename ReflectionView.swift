import SwiftUI

struct ReflectionView: View {
    
    var experiment: Experiment
    @Binding var logs: [SessionLog]
    
    @State private var selectedTag: String? = nil
    @State private var reflectionText: String = ""
    
    let options = [
        "Sustainable",
        "Difficult",
        "Energizing",
        "Inconsistent"
    ]
    
    var body: some View {
        
        ZStack {
            
            LinearGradient(
                colors: [
                    Color(red: 0.16, green: 0.10, blue: 0.30),
                    Color(red: 0.30, green: 0.20, blue: 0.55)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                
                VStack(spacing: 28) {
                    
                    VStack(spacing: 6) {
                        Text("Reflection")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(experiment.title)
                            .font(.system(size: 14))
                            .foregroundColor(Color.white.opacity(0.65))
                    }
                    .padding(.top, 20)
                    
                    
                    // Prompt
                    Text("Did the better-performing routine feel sustainable?")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white.opacity(0.85))
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white.opacity(0.06))
                        )
                    
                    
                    // Quick Options
                    VStack(spacing: 12) {
                        ForEach(options, id: \.self) { option in
                            Button {
                                selectedTag = option
                            } label: {
                                HStack {
                                    Text(option)
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    if selectedTag == option {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.purple)
                                    }
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 18)
                                        .fill(selectedTag == option ? Color.white.opacity(0.12) : Color.white.opacity(0.06))
                                )
                            }
                        }
                    }
                    
                    
                    // Text Reflection
                    VStack(alignment: .leading, spacing: 8) {
                        
                        Text("Additional Thoughts (Optional)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color.white.opacity(0.8))
                        
                        TextEditor(text: $reflectionText)
                            .frame(height: 120)
                            .padding(8)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white.opacity(0.08))
                            )
                            .foregroundColor(.white)
                    }
                    
                    
                    // Save Button
                    NavigationLink {
                        ChooseExperimentView(logs: $logs)
                    } label: {
                        Text("Finish")
                            .font(.system(size: 18, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.purple.opacity(0.8))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                    }
                    .padding(.top, 10)
                    
                    
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 24)
            }
        }
    }
}

