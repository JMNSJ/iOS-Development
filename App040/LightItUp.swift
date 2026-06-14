import SwiftUI

struct LightItUpView: View {
    
    // MARK: - Grid
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    // MARK: - Game State
    @State private var activeCard: Int = Int.random(in: 0..<3)
    @State private var score: Int = 0
    @State private var timeRemaining: Int = 15
    @State private var gameOver = false
    
    @State private var cardTimer: Timer?
    @State private var gameTimer: Timer?
    
    // MARK: - HIGH SCORE (NEW)
    @AppStorage("lightItUpHighScore") private var highScore = 0
    
    var body: some View {
        VStack(spacing: 30) {
            
            Text("Light It Up")
                .font(.largeTitle)
                .bold()
            
            // SCORE SECTION
            HStack {
                VStack(alignment: .leading) {
                    Text("Score: \(score)")
                        .font(.title2)
                    
                    Text("High Score: \(highScore)")
                        .font(.subheadline)
                        .foregroundColor(.green)
                }
                
                Spacer()
                
                Text("Time: \(timeRemaining)s")
                    .font(.title2)
                    .foregroundColor(.red)
            }
            .padding(.horizontal)
            
            // GRID
            LazyVGrid(columns: columns, spacing: 20) {
                
                ForEach(0..<3, id: \.self) { index in
                    
                    CardView(isActive: activeCard == index)
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

// MARK: - GAME LOGIC

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
            
            guard !gameOver else { return }
            
            // penalty for missing card
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
        
        // HIGH SCORE UPDATE
        if score > highScore {
            highScore = score
        }
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
