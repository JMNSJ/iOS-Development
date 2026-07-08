import Combine
import Foundation
import SwiftUI


@MainActor
final class LightItUpViewModel: ObservableObject {
    
    
    // MARK: Game State
    
    @Published var activeCard =
    Int.random(in: 0..<3)
    
    
    @Published var score = 0
    
    
    @Published var timeRemaining = 15
    
    
    @Published var gameOver = false
    
    
    
    // MARK: High Score
    
    @AppStorage("lightItUpHighScore")
    var highScore = 0
    
    
    
    // MARK: Timers
    
    private var cardTimer: Timer?
    
    private var gameTimer: Timer?
    
    
    
    
    func startGame() {
        
        stopTimers()
        
        gameOver = false
        
        score = 0
        
        timeRemaining = 15
        
        activeCard =
        Int.random(in: 0..<3)
        
        
        startCardTimer()
        
        startGameTimer()
    }
    
    
    
    
    private func startCardTimer() {
        
        
        cardTimer =
        Timer.scheduledTimer(
            withTimeInterval: 1.5,
            repeats: true
        ) { [weak self] _ in
            
            guard let self else {
                return
            }
            
            
            guard !self.gameOver else {
                return
            }
            
            
            self.score -= 1
            
            self.activeCard =
            Int.random(in: 0..<3)
        }
    }
    
    
    
    
    private func startGameTimer() {
        
        
        gameTimer =
        Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true
        ) { [weak self] timer in
            
            guard let self else {
                return
            }
            
            
            if self.timeRemaining > 0 {
                
                self.timeRemaining -= 1
                
            } else {
                
                timer.invalidate()
                
                self.gameOver = true
            }
        }
    }
    
    
    
    
    func handleTap(_ index: Int) {
        
        guard !gameOver else {
            return
        }
        
        
        if index == activeCard {
            
            score += 5
            
            activeCard =
            Int.random(in: 0..<3)
            
        } else {
            
            score -= 2
        }
    }
    
    
    
    
    func endGame(
        sessionStore: SessionStore,
        locationService: LocationService
    ) {
        
        gameOver = true
        
        stopTimers()
        
        
        if score > highScore {
            highScore = score
        }
        
        
        let session = GameSession(
            id: UUID(),
            mode: .lightItUp,
            score: score,
            timestamp: Date(),
            latitude: locationService.latitude,
            longitude: locationService.longitude
        )
        
        
        sessionStore.add(session)
    }
    
    
    
    
    func restartGame() {
        
        startGame()
    }
    
    
    
    
    func stopTimers() {
        
        cardTimer?.invalidate()
        cardTimer = nil
        
        
        gameTimer?.invalidate()
        gameTimer = nil
    }
}
