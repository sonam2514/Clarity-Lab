import SwiftUI
import Charts

struct InsightsView: View {
    @State private var animatedConfidence: Double = 0

    var experiment: Experiment
    @Binding var logs: [SessionLog]
    
    var filteredLogs: [SessionLog] {
        logs.filter { $0.experiment == experiment.title }
    }
    
    var averages: [String: Double] {
        var result: [String: Double] = [:]
        
        for variation in experiment.variations {
            let sessions = filteredLogs.filter { $0.variation == variation }
            
            if sessions.isEmpty {
                result[variation] = 0
            } else {
                let avg = sessions.map { $0.focus }.reduce(0, +) / Double(sessions.count)
                result[variation] = avg
            }
        }
        
        return result
    }
    
    var difference: Double {
        guard experiment.variations.count == 2 else { return 0 }
        
        let first = averages[experiment.variations[0]] ?? 0
        let second = averages[experiment.variations[1]] ?? 0
        
        return abs(first - second)
    }
    
    var bestVariation: String {
        averages.max(by: { $0.value < $1.value })?.key ?? ""
    }
    
    var insightText: String {
        guard filteredLogs.count > 1 else {
            return "Log more sessions to unlock comparison insights."
        }
        
        return "\(bestVariation) shows a \(String(format: "%.1f", difference)) point higher focus average."
    }
    
    var confidence: Double {
        let logFactor = min(Double(filteredLogs.count) / 8.0, 1.0)
        let diffFactor = min(difference / 4.0, 1.0)
        return (logFactor + diffFactor) / 2
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
                    
                    // Title Section
                    VStack(spacing: 6) {
                        Text("Insights")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(experiment.title)
                            .font(.system(size: 14))
                            .foregroundColor(Color.white.opacity(0.65))
                    }
                    .padding(.top, 20)
                    
                    
                    if filteredLogs.isEmpty {
                        
                        VStack(spacing: 10) {
                            Text("No Sessions Logged Yet")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Text("Log at least one session for each variation to unlock comparison insights.")
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.white.opacity(0.7))
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(Color.white.opacity(0.06))
                        )
                        
                    } else {
                        
                        // Chart Section
                        VStack {
                            Text("\(filteredLogs.count) Sessions Logged")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color.white.opacity(0.75))
                            
                            Chart {
                                ForEach(experiment.variations, id: \.self) { variation in
                                    BarMark(
                                        x: .value("Variation", variation),
                                        y: .value("Focus", averages[variation] ?? 0)
                                    )
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [
                                                Color.purple.opacity(0.9),
                                                Color.purple.opacity(0.6)
                                            ],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                    .annotation(position: .top) {
                                        Text(String(format: "%.1f", averages[variation] ?? 0))
                                            .font(.caption)
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                            .frame(height: 220)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 22)
                                .fill(Color.white.opacity(0.08))
                        )
                        
                        
                        // Insight Card
                        Text(insightText)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white.opacity(0.06))
                            )
                            .foregroundColor(.white.opacity(0.85))
                        
                        
                        // Confidence Section
                        VStack(spacing: 12) {
                            
                            ZStack {
                                Circle()
                                    .stroke(Color.white.opacity(0.15), lineWidth: 10)
                                
                                Circle()
                                    .trim(from: 0, to: animatedConfidence)
                                    .stroke(
                                        Color.purple.opacity(0.9),
                                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                                    )
                                    .rotationEffect(.degrees(-90))
                                
                                Text("\(Int(confidence * 100))%")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .frame(width: 120, height: 120)
                            
                            Text("Confidence Level")
                                .foregroundColor(Color.white.opacity(0.7))
                        }

                        
                        
                        // Reset Button
                        Button(role: .destructive) {
                            logs.removeAll { $0.experiment == experiment.title }
                        } label: {
                            Text("Reset This Experiment")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color.red.opacity(0.85))
                        }
                        .padding(.top, 4)
                        
                        
                        // Continue Button
                        NavigationLink {
                            DecisionView(
                                experiment: experiment,
                                logs: $logs
                            )
                        } label: {
                            Text("Continue")
                                .font(.system(size: 18, weight: .semibold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.purple.opacity(0.8))
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        .padding(.top, 16)
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
                
                .onAppear {
                    animatedConfidence = 0
                    withAnimation(.easeOut(duration: 1.2)) {
                        animatedConfidence = confidence
                    }
                }

            }
        }
    }

}

