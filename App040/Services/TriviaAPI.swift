import Foundation


final class TriviaAPI {
    
    
    private static let apiURL =
    "https://opentdb.com/api.php?amount=10&type=multiple"
    
    
    
    private let session: URLSession
    
    
    init() {
        
        let configuration =
        URLSessionConfiguration.default
        
        configuration.timeoutIntervalForRequest = 15
        
        configuration.timeoutIntervalForResource = 30
        
        self.session =
        URLSession(configuration: configuration)
    }
    
    
    
    
    func fetchQuestions() async throws -> [TriviaQuestion] {
        
        
        guard let url =
                URL(string: Self.apiURL)
        else {
            throw TriviaAPIError.invalidURL
        }
        
        
        let (data, response) =
        try await session.data(
            from: url
        )
        
        
        
        guard let httpResponse =
                response as? HTTPURLResponse
        else {
            throw TriviaAPIError.invalidResponse
        }
        
        
        
        guard (200...299)
                .contains(httpResponse.statusCode)
        else {
            throw TriviaAPIError.serverError(
                httpResponse.statusCode
            )
        }
        
        
        let decoded =
        try JSONDecoder()
            .decode(
                TriviaResponse.self,
                from: data
            )
        
        
        guard decoded.response_code == 0
        else {
            throw TriviaAPIError.apiError(
                decoded.response_code
            )
        }
        
        
        return decoded.results.map {
            $0.htmlDecoded()
        }
    }
}




enum TriviaAPIError: LocalizedError {
    
    
    case invalidURL
    
    case invalidResponse
    
    case serverError(Int)
    
    case apiError(Int)
    
    
    var errorDescription: String? {
        
        switch self {
            
        case .invalidURL:
            return "Invalid trivia API URL."
            
            
        case .invalidResponse:
            return "Invalid server response."
            
            
        case .serverError(let code):
            return "Server error. HTTP status: \(code)"
            
            
        case .apiError(let code):
            return "Trivia API returned error code \(code)."
        }
    }
}
