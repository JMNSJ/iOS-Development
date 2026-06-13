import SwiftUI
import Combine

struct ContentView: View {

    @State private var score = 0
    @State private var timeRemaining = 10
    @State private var gameOver = false
    @State private var isDarkMode = false

    let timer = Timer.publish(
        every: 1,
        on: .main,
        in: .common
    ).autoconnect()

    var body: some View {

        VStack {
// dark mode button
            Toggle("Dark Mode", isOn: $isDarkMode)
                .padding()

            Text("Score: \(score)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 40)

            Spacer()

            Button(action: {
                if !gameOver {
                    score += 1
                }
            }) {
                Text("Go")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 200, height: 200)
                    .background(Color.orange.opacity(0.75))
                    .clipShape(Circle())
            }
            .disabled(gameOver)

            if gameOver {

                VStack(spacing: 10) {

                    Text("Game Over!")
                        .font(.title)
                        .foregroundColor(.red)

                    Text("Good Try! Start Another Game")
                        .font(.title)
                        .foregroundColor(.purple)

                    Text("Final Score: \(score)")
                        .font(.headline)

                    Button("Let's Play Again!") {
                        score = 0
                        timeRemaining = 10
                        gameOver = false
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
            }

            Spacer()

            Text("Time: \(timeRemaining)")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.bottom, 40)

        }
        .padding()
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .onReceive(timer) { _ in

            guard !gameOver else { return }

            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                gameOver = true
            }
        }
    }
}
