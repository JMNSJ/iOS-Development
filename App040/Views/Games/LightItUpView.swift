import SwiftUI
import Combine
import Foundation


// MARK: - ViewModel

@MainActor
final class LightItUpVM: ObservableObject {
    
    @Published var activeCard = Int.random(in: 0..<3)
    
    @Published var score = 0
    
    @Published var timeRemaining = 15
    
    @Published var gameOver = false
    
    
    @AppStorage("lightItUpHighScore")
    var highScore = 0
    
    
    private var cardTimer: Timer?
    private var gameTimer: Timer?
    
    
    @objc private func handleCardTimer(_ timer: Timer) {
        guard !gameOver else { return }
        // All state is main-actor isolated, safe to mutate here
        score -= 1
        activeCard = Int.random(in: 0..<3)
    }

    @objc private func handleGameTimer(_ timer: Timer) {
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            timer.invalidate()
            endGame()
        }
    }
    
    
    private func startCardTimer() {
        // Invalidate any existing timer first (defensive; startGame also stops timers)
        cardTimer?.invalidate()
        cardTimer = Timer.scheduledTimer(timeInterval: 1.5,
                                         target: self,
                                         selector: #selector(handleCardTimer(_:)),
                                         userInfo: nil,
                                         repeats: true)
        // Ensure it runs on the main run loop
        RunLoop.main.add(cardTimer!, forMode: .common)
    }
    
    
    private func startGameTimer() {
        // Invalidate any existing timer first (defensive; startGame also stops timers)
        gameTimer?.invalidate()
        gameTimer = Timer.scheduledTimer(timeInterval: 1,
                                         target: self,
                                         selector: #selector(handleGameTimer(_:)),
                                         userInfo: nil,
                                         repeats: true)
        // Ensure it runs on the main run loop
        RunLoop.main.add(gameTimer!, forMode: .common)
    }
    
    
    func startGame() {
        
        stopTimers()
        
        gameOver = false
        score = 0
        timeRemaining = 15
        
        activeCard = Int.random(in: 0..<3)
        
        startCardTimer()
        startGameTimer()
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



// MARK: - Game View

struct LightItUpView: View {
    
    @StateObject private var vm = LightItUpViewModel()
    
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            
            Text("💡 Light It Up")
                .font(.largeTitle)
                .bold()
            
            
            HStack {
                
                Text("Score: \(vm.score)")
                
                Spacer()
                
                Text("Time: \(vm.timeRemaining)")
            }
            .padding(.horizontal)
            
            
            Text("High Score: \(vm.highScore)")
                .font(.headline)
            
            
            LazyVGrid(
                columns: Array(
                    repeating: GridItem(.flexible()),
                    count: 3
                ),
                spacing: 20
            ) {
                
                ForEach(0..<3, id: \.self) { index in
                    
                    cardView(
                        isActive: vm.activeCard == index
                    )
                    .onTapGesture {
                        vm.handleTap(index)
                    }
                }
            }
            .padding()
            
            
            if vm.gameOver {
                
                VStack(spacing: 15) {
                    
                    Text("Game Over")
                        .font(.title)
                        .bold()
                    
                    
                    Text("Final Score: \(vm.score)")
                    
                    
                    Button {
                        vm.restartGame()
                    } label: {
                        
                        Text("Restart")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
                .padding()
            }
        }
        .padding()
        .onAppear {
            vm.startGame()
        }
        .onDisappear {
            vm.stopTimers()
        }
    }
    
    
    // MARK: - Card View (Merged from CardView.swift)
    
    private func cardView(isActive: Bool) -> some View {
        
        RoundedRectangle(cornerRadius: 20)
            .fill(
                isActive
                ? Color.yellow
                : Color.gray.opacity(0.3)
            )
            .frame(height: 150)
            .overlay {
                
                Image(
                    systemName:
                        isActive
                        ? "lightbulb.fill"
                        : "lightbulb"
                )
                .font(.system(size: 40))
                .foregroundColor(
                    isActive
                    ? .orange
                    : .gray
                )
            }
            .shadow(radius: 5)
    }
}
