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
    
    // MARK: Load Questions
    func loadQuestions() async {
        isLoading = true
        errorMessage = nil
        
        do {
            questions = try await service.fetchQuestions()
            currentIndex = 0
            score = 0
            streak = 0
            setupOptions()
        } catch {
            errorMessage = "Failed to load questions. Please try again."
        }
        
        isLoading = false
    }
    
    // MARK: Setup Options
    func setupOptions() {
        guard currentIndex < questions.count else { return }
        
        let q = questions[currentIndex]
        
        var all = q.incorrect_answers
        all.append(q.correct_answer)
        all.shuffle()
        
        options = all
        selectedAnswer = nil
    }
    
    // MARK: Answer Selection
    func selectAnswer(_ answer: String) {
        guard selectedAnswer == nil else { return }
        
        selectedAnswer = answer
        
        let correct = questions[currentIndex].correct_answer
        
        if answer == correct {
            streak += 1
            score += 10 + (streak >= 3 ? 5 : 0)
        } else {
            streak = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.nextQuestion()
        }
    }
    
    // MARK: Next Question
    func nextQuestion() {
        if currentIndex + 1 < questions.count {
            currentIndex += 1
            setupOptions()
        }
    }
    
    // MARK: Check Correct
    func isCorrect(_ option: String) -> Bool {
        questions[currentIndex].correct_answer == option
    }
}
