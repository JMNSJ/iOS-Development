import Combine
import Foundation
import SwiftUI

final class LightItUpViewModel: ObservableObject {
    
    // MARK: - Game State
    @Published var activeCard: Int = Int.random(in: 0..<3)
    @Published var score: Int = 0
    @Published var timeRemaining: Int = 15
    @Published var gameOver = false
    
    // MARK: - High Score
    @AppStorage("lightItUpHighScore") var highScore = 0
    
    // MARK: - Timers
    private var cardTimer: Timer?
    private var gameTimer: Timer?
    
    // MARK: - Game Start
    func startGame() {
        stopTimers()
        
        gameOver = false
        score = 0
        timeRemaining = 15
        activeCard = Int.random(in: 0..<3)
        
        startCardTimer()
        startGameTimer()
    }
    
    private func startCardTimer() {
        cardTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { _ in
            
            guard !self.gameOver else { return }
            
            self.score -= 1
            self.activeCard = Int.random(in: 0..<3)
        }
    }
    
    private func startGameTimer() {
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                timer.invalidate()
                self.endGame()
            }
        }
    }
    
    func handleTap(_ index: Int) {
        guard !gameOver else { return }
        
        if index == activeCard {
            score += 5
            activeCard = Int.random(in: 0..<3)
        } else {
            score -= 2
        }
    }
    
    func endGame() {
        gameOver = true
        stopTimers()
        
        if score > highScore {
            highScore = score
        }
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
