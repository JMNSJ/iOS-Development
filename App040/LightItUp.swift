import SwiftUI

struct LightItUpView: View {
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @State private var activeCard: Int = Int.random(in: 0..<3)
    @State private var score: Int = 0
    @State private var timeRemaining: Int = 15
    @State private var gameOver = false
    
    @State private var cardTimer: Timer?
    @State private var gameTimer: Timer?
    
    var body: some View {
        VStack(spacing: 30) {
            
            Text("Light It Up")
                .font(.largeTitle)
                .bold()
            
            HStack {
                Text("Score: \(score)")
                    .font(.title2)
                
                Spacer()
                
                Text("Time: \(timeRemaining)s")
                    .font(.title2)
                    .foregroundColor(.red)
            }
            .padding(.horizontal)
            
            LazyVGrid(columns: columns, spacing: 20) {
                
                ForEach(0..<3, id: \.self) { index in
                    
                    CardView(
                        isActive: activeCard == index
                    )
                    .onTapGesture {
                        handleTap(index)
                    }
                }
            }
            .padding()
            
            Spacer()
        }
        .alert("Game Over", isPresented: $gameOver) {
            
            Button("Play Again") {
                restartGame()
            }
            
        } message: {
            Text("Final Score: \(score)")
        }
        .onAppear {
            startGame()
        }
        .onDisappear {
            stopTimers()
        }
    }
}

// MARK: - Game Logic

extension LightItUpView {
    
    private func startGame() {
        
        stopTimers()
        
        gameOver = false
        score = 0
        timeRemaining = 15
        activeCard = Int.random(in: 0..<3)
        
        startCardTimer()
        startGameTimer()
    }
    
    private func startCardTimer() {
        
        cardTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            
            if gameOver { return }
            
            // Missed active card
            score -= 1
            
            activeCard = Int.random(in: 0..<3)
        }
    }
    
    private func startGameTimer() {
        
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer.invalidate()
                endGame()
            }
        }
    }
    
    private func handleTap(_ index: Int) {
        
        guard !gameOver else { return }
        
        if index == activeCard {
            
            score += 5
            
            activeCard = Int.random(in: 0..<3)
            
        } else {
            
            score -= 2
        }
    }
    
    private func endGame() {
        
        gameOver = true
        stopTimers()
    }
    
    private func restartGame() {
        
        startGame()
    }
    
    private func stopTimers() {
        
        cardTimer?.invalidate()
        cardTimer = nil
        
        gameTimer?.invalidate()
        gameTimer = nil
    }
}
