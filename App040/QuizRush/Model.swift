import Foundation

// MARK: - API Response
struct TriviaResponse: Codable {
    let results: [TriviaQuestion]
}

// MARK: - Question Model
struct TriviaQuestion: Codable, Identifiable {
    var id = UUID()
    
    let question: String
    let correct_answer: String
    let incorrect_answers: [String]
}
