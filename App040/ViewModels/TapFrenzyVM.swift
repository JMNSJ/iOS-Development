import Combine
import Foundation
import SwiftUI

@MainActor
final class TapFrenzyVM: ObservableObject {

    @Published var score = 0
    @Published var timeRemaining = 10
    @Published var gameOver = false
    @Published var buttonSize: CGFloat = 200
    @Published var buttonPosition: CGPoint = .zero
    @Published var isDarkMode = false

    @AppStorage("tapFrenzyHighScore")
    var highScore = 0

    private var timer: Timer?

    func startGame(size: CGSize) {
        resetGame(size: size)
        startTimer()
    }

    private func startTimer() {
        // Always invalidate any existing timer before starting a new one
        timer?.invalidate()

        let timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(timerFired),
            userInfo: nil,
            repeats: true
        )
        self.timer = timer
        RunLoop.main.add(timer, forMode: .common)
    }

    @objc private func timerFired() {
        guard !gameOver else { return }

        if timeRemaining > 0 {
            timeRemaining -= 1

            withAnimation(.easeInOut(duration: 0.4)) {
                let newSize = CGFloat(timeRemaining * 15 + 50)
                buttonSize = max(50, newSize)
            }
        } else {
            endGame()
        }
    }

    func handleTap(in size: CGSize) {
        guard !gameOver else { return }

        score += 1

        withAnimation(.spring()) {
            buttonPosition = CGPoint(
                x: CGFloat.random(in: buttonSize / 2...size.width - buttonSize / 2),
                y: CGFloat.random(in: 150...size.height - 150)
            )
        }
    }

    func endGame() {
        guard !gameOver else { return }

        gameOver = true
        stopTimer()

        if score > highScore {
            highScore = score
        }
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
            buttonPosition = CGPoint(x: size.width / 2, y: size.height / 2)
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    deinit {
        timer?.invalidate()
    }
}
