import Combine
import Foundation

@MainActor
class QuizViewModel: ObservableObject {
    
    @Published var questions: [TriviaQuestion] = []
    @Published var currentIndex = 0
    
    @Published var options: [String] = []
    @Published var selectedAnswer: String? = nil
    
    @Published var score = 0
    @Published var streak = 0
    
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    private let service = TriviaService()
    
    // MARK: Start Game
    func startGame() {
        Task {
            await loadQuestions()
        }
    }
    
    // MARK: Load Questions (Async/Await)
    func loadQuestions() async {
        
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedQuestions = try await service.fetchQuestions()
            
            guard !fetchedQuestions.isEmpty else {
                throw NSError(domain: "QuizRush", code: -1, userInfo: [
                    NSLocalizedDescriptionKey: "No questions received from API"
                ])
            }
            
            questions = fetchedQuestions
            currentIndex = 0
            score = 0
            streak = 0
            
            setupOptions()
            
        } catch {
            print("❌ ERROR:", error)
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    // MARK: Setup Options
    func setupOptions() {
        
        guard currentIndex < questions.count else { return }
        
        let question = questions[currentIndex]
        
        var allOptions = question.incorrect_answers
        allOptions.append(question.correct_answer)
        allOptions.shuffle()
        
        options = allOptions
        selectedAnswer = nil
    }
    
    // MARK: Select Answer
    func selectAnswer(_ answer: String) {
        
        guard selectedAnswer == nil else { return }
        
        selectedAnswer = answer
        
        let correct = questions[currentIndex].correct_answer
        
        if answer == correct {
            streak += 1
            let bonus = streak >= 3 ? 5 : 0
            score += 10 + bonus
        } else {
            streak = 0
        }
        
        Task {
            try? await Task.sleep(nanoseconds: 800_000_000)
            nextQuestion()
        }
    }
    
    // MARK: Next Question
    func nextQuestion() {
        
        if currentIndex + 1 < questions.count {
            currentIndex += 1
            setupOptions()
        } else {
            print("🎉 Game Finished! Score: \(score)")
        }
    }
}
