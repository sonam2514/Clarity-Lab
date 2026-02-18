import Foundation

struct SessionLog: Identifiable {
    
    let id = UUID()
    
    var experiment: String
    var variation: String
    var focus: Double
    var energy: Double
    var satisfaction: Double
    
    // Helpful computed property
    var averageScore: Double {
        (focus + energy + satisfaction) / 3
    }
}

