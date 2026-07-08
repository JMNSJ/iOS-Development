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
    
    @objc private func cardTimerFired(_ timer: Timer) {
        guard !gameOver else { return }
        score -= 1
        activeCard = Int.random(in: 0..<3)
    }

    @objc private func gameTimerFired(_ timer: Timer) {
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            timer.invalidate()
            gameOver = true
        }
    }
    
    
    
    
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
        
        
        cardTimer = Timer.scheduledTimer(timeInterval: 1.5,
                                         target: self,
                                         selector: #selector(cardTimerFired(_:)),
                                         userInfo: nil,
                                         repeats: true)
    }
    
    
    
    
    private func startGameTimer() {
        
        
        gameTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                         target: self,
                                         selector: #selector(gameTimerFired(_:)),
                                         userInfo: nil,
                                         repeats: true)
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


