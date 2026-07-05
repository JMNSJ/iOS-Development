import Foundation

class TriviaService {
    
    func fetchQuestions() async throws -> [TriviaQuestion] {
        
        let urlString = "https://opentdb.com/api.php?amount=10&type=multiple"
        let url = URL(string: urlString)!
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoded = try JSONDecoder().decode(TriviaResponse.self, from: data)
        
        return decoded.results
    }
}
