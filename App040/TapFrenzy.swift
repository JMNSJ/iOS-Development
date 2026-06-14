import SwiftUI
import Combine

struct TapFrenzy: View {

    // MARK: - Game State
    @State private var score = 0
    @State private var timeRemaining = 10
    @State private var gameOver = false
    @State private var isDarkMode = false

    @State private var buttonSize: CGFloat = 200
    @State private var buttonPosition: CGPoint = .zero

    // MARK: - HIGH SCORE (NEW)
    @AppStorage("tapFrenzyHighScore") private var highScore = 0

    let timer = Timer.publish(
        every: 1,
        on: .main,
        in: .common
    ).autoconnect()

    var body: some View {

        GeometryReader { geo in

            ZStack {

                VStack {

                    // Dark Mode Toggle
                    Toggle("Dark Mode", isOn: $isDarkMode)
                        .padding(.horizontal)

                    // Score + High Score
                    Text("Score: \(score)")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("High Score: \(highScore)")
                        .font(.title3)
                        .foregroundColor(.green)

                    Spacer()

                    // Game Over Section
                    if gameOver {

                        VStack(spacing: 15) {

                            Text("Game Over!")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.red)

                            Text("Good Try! Start Another Game")
                                .font(.headline)
                                .foregroundColor(.purple)

                            Text("Final Score: \(score)")
                                .font(.title3)

                            // NEW: High score update message
                            if score == highScore {
                                Text("🎉 New High Score!")
                                    .font(.headline)
                                    .foregroundColor(.green)
                            }

                            Button("Let's Play Again!") {

                                restartGame(geo: geo)
                            }
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .padding()
                    }

                    Spacer()

                    // Timer
                    Text("Time: \(timeRemaining)")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .padding(.bottom, 40)
                }

                // Moving Button
                Button(action: {

                    guard !gameOver else { return }

                    score += 1

                    withAnimation(.spring()) {

                        buttonPosition = CGPoint(
                            x: CGFloat.random(
                                in: buttonSize/2...(geo.size.width - buttonSize/2)
                            ),
                            y: CGFloat.random(
                                in: 150...(geo.size.height - 150)
                            )
                        )
                    }

                }) {

                    Text("Go")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(width: buttonSize, height: buttonSize)
                        .background(Color.orange.opacity(0.8))
                        .clipShape(Circle())
                }
                .position(buttonPosition)
                .disabled(gameOver)
            }
            .onAppear {

                buttonPosition = CGPoint(
                    x: geo.size.width / 2,
                    y: geo.size.height / 2
                )
            }
            .onReceive(timer) { _ in

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
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }

    // MARK: - GAME FUNCTIONS

    private func endGame() {

        gameOver = true

        // HIGH SCORE CHECK
        if score > highScore {
            highScore = score
        }
    }

    private func restartGame(geo: GeometryProxy) {

        score = 0
        timeRemaining = 10
        gameOver = false
        buttonSize = 200

        withAnimation(.spring()) {
            buttonPosition = CGPoint(
                x: geo.size.width / 2,
                y: geo.size.height / 2
            )
        }
    }
}

#Preview {
    TapFrenzy()
}
