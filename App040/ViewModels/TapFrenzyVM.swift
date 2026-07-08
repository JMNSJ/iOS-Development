import Combine
import Foundation
import SwiftUI


@MainActor
final class TapFrenzyVM: ObservableObject {
    
    
    // MARK: - Game State
    
    @Published var score = 0
    
    @Published var timeRemaining = 10
    
    @Published var gameOver = false
    
    @Published var buttonSize: CGFloat = 200
    
    @Published var buttonPosition: CGPoint = .zero
    
    @Published var isDarkMode = false
    
    
    // MARK: - High Score
    
    @AppStorage("tapFrenzyHighScore")
    var highScore = 0
    
    
    // MARK: - Timer
    
    private var timer: Timer?
    
    
    
    // MARK: - Start Game
    
    func startGame(size: CGSize) {
        
        resetGame(size: size)
        
        startTimer()
    }
    
    
    
    private func startTimer() {
        
        timer?.invalidate()
        
        
        timer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true
        ) { [weak self] _ in
            
            guard let self else { return }
            
            
            if self.gameOver {
                return
            }
            
            
            if self.timeRemaining > 0 {
                
                self.timeRemaining -= 1
                
                
                withAnimation(.easeInOut(duration: 0.4)) {
                    
                    let newSize =
                    CGFloat(self.timeRemaining * 15 + 50)
                    
                    self.buttonSize =
                    max(50, newSize)
                }
                
            } else {
                
                self.gameOver = true
            }
        }
    }
    
    
    
    
    func handleTap(in size: CGSize) {
        
        guard !gameOver else {
            return
        }
        
        
        score += 1
        
        
        withAnimation(.spring()) {
            
            buttonPosition = CGPoint(
                x: CGFloat.random(
                    in: buttonSize/2...(size.width - buttonSize/2)
                ),
                y: CGFloat.random(
                    in: 150...(size.height - 150)
                )
            )
        }
    }
    
    
    
    
    func endGame(
        sessionStore: SessionStore,
        locationService: LocationService
    ) {
        
        guard !gameOver else {
            return
        }
        
        
        gameOver = true
        
        timer?.invalidate()
        timer = nil
        
        
        if score > highScore {
            highScore = score
        }
        
        
        let session = GameSession(
            id: UUID(),
            mode: .tapFrenzy,
            score: score,
            timestamp: Date(),
            latitude: locationService.latitude,
            longitude: locationService.longitude
        )
        
        
        sessionStore.add(session)
    }
    
    
    
    
    func restartGame(size: CGSize) {
        
        resetGame(size: size)
        
        startTimer()
    }
    
    
    
    
    private func resetGame(size: CGSize) {
        
        score = 0
        
        timeRemaining = 10
        
        gameOver = false
        
        buttonSize = 200
        
        
        withAnimation(.spring()) {
            
            buttonPosition = CGPoint(
                x: size.width / 2,
                y: size.height / 2
            )
        }
    }
}
