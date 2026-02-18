import Foundation

struct Experiment: Identifiable, Hashable {
    
    var id: String { title }   
    
    let title: String
    let variations: [String]
}

