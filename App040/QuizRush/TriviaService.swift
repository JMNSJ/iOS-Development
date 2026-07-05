import Foundation

class TriviaService {
    
    func fetchQuestions() async throws -> [TriviaQuestion] {
        
        let url = URL(string: "https://opentdb.com/api.php?amount=10&type=multiple")!
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let http = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoded = try JSONDecoder().decode(TriviaResponse.self, from: data)
        
        // response_code 0 == success. Other codes mean OpenTDB returned no usable data.
        guard decoded.response_code == 0 else {
            throw NSError(domain: "QuizRush", code: decoded.response_code, userInfo: [
                NSLocalizedDescriptionKey: "Trivia API returned an error (code \(decoded.response_code))"
            ])
        }
        
        // Decode HTML entities before handing questions off to the view model.
        return decoded.results.map { $0.htmlDecoded() }
    }
}
