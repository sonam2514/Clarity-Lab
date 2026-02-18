import SwiftUI
import Charts

struct DecisionView: View {
    
    var experiment: Experiment
    @Binding var logs: [SessionLog]
    
    var filteredLogs: [SessionLog] {
        logs.filter { $0.experiment == experiment.title }
    }
    
    var bestVariation: String {
        let grouped = Dictionary(grouping: filteredLogs, by: { $0.variation })
        let averages = grouped.mapValues {
            $0.map { $0.focus }.reduce(0, +) / Double($0.count)
        }
        return averages.max(by: { $0.value < $1.value })?.key ?? ""
    }
    
    var confidence: Double {
        let grouped = Dictionary(grouping: filteredLogs, by: { $0.variation })
        let averages = grouped.mapValues {
            $0.map { $0.focus }.reduce(0, +) / Double($0.count)
        }
        
        let values = Array(averages.values)
        if values.count == 2 {
            let diff = abs(values[0] - values[1])
            let logFactor = min(Double(filteredLogs.count) / 8.0, 1.0)
            let diffFactor = min(diff / 4.0, 1.0)
            return (logFactor + diffFactor) / 2
        }
        
        return 0
    }
    
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
                    
                    // Title
                    VStack(spacing: 6) {
                        Text("Next Step")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(experiment.title)
                            .font(.system(size: 14))
                            .foregroundColor(Color.white.opacity(0.65))
                    }
                    .padding(.top, 20)
                    
                    
                    // Trend Chart
                    if !filteredLogs.isEmpty {
                        
                        VStack(alignment: .leading, spacing: 12) {
                            
                            Text("Focus Trend Over Sessions")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(Color.white.opacity(0.8))
                            
                            Chart {
                                ForEach(Array(filteredLogs.enumerated()), id: \.offset) { index, log in
                                    LineMark(
                                        x: .value("Session", index + 1),
                                        y: .value("Focus", log.focus)
                                    )
                                    .foregroundStyle(Color.purple.opacity(0.9))
                                    
                                    PointMark(
                                        x: .value("Session", index + 1),
                                        y: .value("Focus", log.focus)
                                    )
                                    .foregroundStyle(.white)
                                }
                            }
                            .frame(height: 200)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 22)
                                .fill(Color.white.opacity(0.08))
                        )
                    }
                    
                    
                    // Smart Recommendation
                    if !bestVariation.isEmpty {
                        
                        VStack(spacing: 10) {
                            
                            Text("Recommendation")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                            
                            if confidence > 0.6 {
                                Text("\(bestVariation) appears consistently stronger. Consider applying it for the next few sessions.")
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color.white.opacity(0.85))
                            } else {
                                Text("Early data suggests \(bestVariation) may perform better. Log more sessions to confirm.")
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color.white.opacity(0.75))
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white.opacity(0.06))
                        )
                    }

                    
                    
                    // Action Buttons
                    VStack(spacing: 16) {
                        
                        NavigationLink {
                            LogSessionView(
                                experiment: experiment,
                                logs: $logs
                            )
                        } label: {
                            decisionButton(title: "Continue This Experiment")
                        }
                        
                        NavigationLink {
                            ChooseExperimentView(logs: $logs)
                        } label: {
                            decisionButton(title: "Try Another Experiment")
                        }
                        
                        NavigationLink {
                            ReflectionView(
                                experiment: experiment,
                                logs: $logs
                            )
                        } label: {
                            decisionButton(title: "Reflect On This Routine")
                        }
                    }
                    .padding(.horizontal, 24)
                }
            }
        }
    }
    
    func decisionButton(title: String) -> some View {
        Text(title)
            .font(.system(size: 17, weight: .semibold))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color.purple.opacity(0.8))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

