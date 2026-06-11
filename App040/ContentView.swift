import SwiftUI
import Combine

struct ContentView: View {

    @State private var score = 0
    @State private var timeRemaining = 30
    @State private var gameOver = false

    let timer = Timer.publish(
        every: 1,
        on: .main,
        in: .common
    ).autoconnect()

    var body: some View {

        VStack {

            // Score
            Text("Score: \(score)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 40)

            Spacer()

            // Tap Button
            Button(action: {

                if !gameOver {
                    score += 1
                }

            }) {

                Text("TAP")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 180, height: 180)
                    .background(Color.blue)
                    .clipShape(Circle())
            }
            .disabled(gameOver)

            // Game Over Section
            if gameOver {

                VStack(spacing: 10) {

                    Text("Game Over!")
                        .font(.title)
                        .foregroundColor(.red)

                    Text("Final Score: \(score)")
                        .font(.headline)

                    Button("Restart Game") {
                        score = 0
                        timeRemaining = 30
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

            // Timer
            Text("Time: \(timeRemaining)")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.bottom, 40)

        }
        .padding()
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

#Preview {
    ContentView()
}
