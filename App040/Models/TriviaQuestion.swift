import Foundation
import UIKit


struct TriviaResponse: Codable {
    
    let response_code: Int
    let results: [TriviaQuestion]
}



struct TriviaQuestion: Codable, Identifiable {
    
    var id: UUID = UUID()
    
    let question: String
    let correct_answer: String
    let incorrect_answers: [String]
    
    
    private enum CodingKeys: String, CodingKey {
        case question
        case correct_answer
        case incorrect_answers
    }
    
    
    init(
        id: UUID = UUID(),
        question: String,
        correct_answer: String,
        incorrect_answers: [String]
    ) {
        self.id = id
        self.question = question
        self.correct_answer = correct_answer
        self.incorrect_answers = incorrect_answers
    }
    
    
    // Converts OpenTDB HTML encoded text
    func htmlDecoded() -> TriviaQuestion {
        
        TriviaQuestion(
            id: id,
            question: question.decodedHTML,
            correct_answer: correct_answer.decodedHTML,
            incorrect_answers: incorrect_answers.map {
                $0.decodedHTML
            }
        )
    }
    
    
    // Randomized answers for multiple choice buttons
    var shuffledAnswers: [String] {
        
        (
            incorrect_answers +
            [correct_answer]
        )
        .shuffled()
    }
}



extension String {
    
    
    var decodedHTML: String {
        
        guard let data = self.data(using: .utf8)
        else {
            return self
        }
        
        
        let options:
        [NSAttributedString.DocumentReadingOptionKey : Any] = [
            
            .documentType:
                NSAttributedString.DocumentType.html,
            
            .characterEncoding:
                String.Encoding.utf8.rawValue
        ]
        
        
        guard let attributed =
                try? NSAttributedString(
                    data: data,
                    options: options,
                    documentAttributes: nil
                )
        else {
            return self
        }
        
        
        return attributed.string
    }
}
