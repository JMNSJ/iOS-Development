import Combine
import Foundation


@MainActor
final class QuizRushVM: ObservableObject {
    
    
    enum GameState {
        case playing
        case finished
    }
    
    
    @Published var gameState: GameState = .playing
    
    
    @Published var questions: [TriviaQuestion] = []
    
    @Published var currentIndex = 0
    
    
    @Published var options: [String] = []
    
    
    @Published var selectedAnswer: String?
    
    
    @Published var score = 0
    
    @Published var streak = 0
    
    
    @Published var isLoading = false
    
    @Published var errorMessage: String?
    
    
    private let api = TriviaAPI()
    
    
    func startGame() {
        
        gameState = .playing
        
        Task {
            await loadQuestions()
        }
    }
    
    
    
    func loadQuestions() async {
        
        isLoading = true
        
        errorMessage = nil
        
        
        do {
            
            let result =
            try await api.fetchQuestions()
            
            
            questions = result
            
            currentIndex = 0
            
            score = 0
            
            streak = 0
            
            setupOptions()
            
        }
        catch {
            
            errorMessage =
            error.localizedDescription
        }
        
        
        isLoading = false
    }
    
    
    
    func setupOptions() {
        
        guard currentIndex < questions.count
        else {
            return
        }
        
        
        options =
        questions[currentIndex]
            .shuffledAnswers
        
        selectedAnswer = nil
    }
    
    
    
    func selectAnswer(_ answer:String) {
        
        
        guard selectedAnswer == nil,
              currentIndex < questions.count
        else {
            return
        }
        
        
        selectedAnswer = answer
        
        
        if answer ==
            questions[currentIndex].correct_answer {
            
            streak += 1
            
            score +=
            10 + (streak >= 3 ? 5 : 0)
            
        }
        else {
            
            streak = 0
        }
        
        
        Task {
            
            try? await Task.sleep(
                nanoseconds: 800_000_000
            )
            
            
            nextQuestion()
        }
    }
    
    
    
    func nextQuestion() {
        
        
        if currentIndex + 1 < questions.count {
            
            currentIndex += 1
            
            setupOptions()
            
        }
        else {
            
            gameState = .finished
        }
    }
    
    
    
    func finishGame(
        sessionStore: SessionStore,
        locationService: LocationService
    ) {
        
        
        let session = GameSession(
            id: UUID(),
            mode: .quizRush,
            score: score,
            timestamp: Date(),
            latitude: locationService.latitude,
            longitude: locationService.longitude
        )
        
        
        sessionStore.add(session)
    }
}
