import SwiftUI

struct LogSessionView: View {
    
    var experiment: Experiment
    @Binding var logs: [SessionLog]
    
    @State private var variation: String = ""
    @State private var focus: Double = 3
    @State private var energy: Double = 3
    @State private var satisfaction: Double = 3
    
    var body: some View {
        
        ZStack {
            
            // Deep Purple Background
            LinearGradient(
                colors: [
                    Color(red: 0.18, green: 0.12, blue: 0.35),
                    Color(red: 0.28, green: 0.20, blue: 0.55)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 28) {
                
                Text(experiment.title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.white.opacity(0.9))
                
                // Segmented Picker
                Picker("", selection: $variation) {
                    ForEach(experiment.variations, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
                .pickerStyle(.segmented)
                .tint(Color.purple.opacity(0.8))
                
                sliderCard(title: "Focus", value: $focus)
                sliderCard(title: "Energy", value: $energy)
                sliderCard(title: "Satisfaction", value: $satisfaction)
                
                NavigationLink {
                    InsightsView(
                        experiment: experiment,
                        logs: $logs
                    )
                } label: {
                    Text("Save Session")
                        .font(.system(size: 18, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            Color.purple.opacity(0.9)
                        )
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 6)
                }
                .simultaneousGesture(TapGesture().onEnded {
                    
                    let newLog = SessionLog(
                        experiment: experiment.title,
                        variation: variation,
                        focus: focus,
                        energy: energy,
                        satisfaction: satisfaction
                    )
                    
                    logs.append(newLog)
                })
                
                Spacer()
            }
            .padding(24)
        }
        .onAppear {
            variation = experiment.variations.first ?? ""
        }
    }
    
    // Styled Slider Card
    func sliderCard(title: String, value: Binding<Double>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            
            Text("\(title): \(Int(value.wrappedValue))")
                .foregroundColor(Color.white.opacity(0.85))
            
            Slider(value: value, in: 1...5, step: 1)
                .tint(Color.purple.opacity(0.8))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.08))
        )
    }
}

