import SwiftUI
import Combine

struct ContentView: View {

    @State private var score = 0
    @State private var timeRemaining = 10
    @State private var gameOver = false
    @State private var isDarkMode = false

    @State private var buttonSize: CGFloat = 200
    @State private var buttonPosition: CGPoint = .zero

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

                    // Score
                    Text("Score: \(score)")
                        .font(.largeTitle)
                        .fontWeight(.bold)

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

                            Button("Let's Play Again!") {

                                score = 0
                                timeRemaining = 10
                                gameOver = false
                                buttonSize = 200

                                // Return button to center
                                withAnimation(.spring()) {
                                    buttonPosition = CGPoint(
                                        x: geo.size.width / 2,
                                        y: geo.size.height / 2
                                    )
                                }
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

                    // Move button after every tap
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
                        .frame(
                            width: buttonSize,
                            height: buttonSize
                        )
                        .background(Color.orange.opacity(0.8))
                        .clipShape(Circle())
                }
                .position(buttonPosition)
                .disabled(gameOver)
            }
            .onAppear {

                // Start button in center
                buttonPosition = CGPoint(
                    x: geo.size.width / 2,
                    y: geo.size.height / 2
                )
            }
            .onReceive(timer) { _ in

                guard !gameOver else { return }

                if timeRemaining > 0 {

                    timeRemaining -= 1

                    // Shrink button as time decreases
                    withAnimation(.easeInOut(duration: 0.4)) {

                        let newSize = CGFloat(timeRemaining * 15 + 50)
                        buttonSize = max(50, newSize)
                    }

                } else {

                    gameOver = true

                    // Return button to center when game ends
                    withAnimation(.spring()) {
                        buttonPosition = CGPoint(
                            x: geo.size.width / 2,
                            y: geo.size.height / 2
                        )
                    }
                }
            }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

#Preview {
    ContentView()
}
