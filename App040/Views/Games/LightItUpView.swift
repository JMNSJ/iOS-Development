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

    private weak var sessionStore: SessionStore?
    private weak var locationService: LocationService?
    private var hasSavedSession = false

    @objc private func handleCardTimer(_ timer: Timer) {
        guard !gameOver else { return }

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
        cardTimer?.invalidate()

        cardTimer = Timer.scheduledTimer(
            timeInterval: 1.5,
            target: self,
            selector: #selector(handleCardTimer(_:)),
            userInfo: nil,
            repeats: true
        )

        RunLoop.main.add(cardTimer!, forMode: .common)
    }

    private func startGameTimer() {
        gameTimer?.invalidate()

        gameTimer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(handleGameTimer(_:)),
            userInfo: nil,
            repeats: true
        )

        RunLoop.main.add(gameTimer!, forMode: .common)
    }

    func startGame(sessionStore: SessionStore, locationService: LocationService) {
        self.sessionStore = sessionStore
        self.locationService = locationService
        hasSavedSession = false

        stopTimers()

        gameOver = false
        score = 0
        timeRemaining = 15

        activeCard = Int.random(in: 0..<3)

        startCardTimer()
        startGameTimer()
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

        saveSessionIfNeeded()
    }

    private func saveSessionIfNeeded() {
        guard !hasSavedSession, let sessionStore, let locationService else { return }
        hasSavedSession = true

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

    func restartGame(sessionStore: SessionStore, locationService: LocationService) {
        startGame(sessionStore: sessionStore, locationService: locationService)
    }

    func stopTimers() {
        cardTimer?.invalidate()
        cardTimer = nil

        gameTimer?.invalidate()
        gameTimer = nil
    }

    deinit {
        cardTimer?.invalidate()
        gameTimer?.invalidate()
    }
}

/// MARK: - Game View

struct LightItUpView: View {

    @StateObject private var vm = LightItUpVM()

    @EnvironmentObject var sessionStore: SessionStore
    @EnvironmentObject var locationService: LocationService

    @State private var animateBackground = false
    @State private var tappedCard: Int? = nil


    var body: some View {

        ZStack {

            // MARK: Dark Animated Background

            LinearGradient(
                colors: [
                    Color.black,
                    Color.blue.opacity(0.5),
                    Color.purple.opacity(0.6)
                ],
                startPoint: animateBackground ? .topLeading : .bottomTrailing,
                endPoint: animateBackground ? .bottomTrailing : .topLeading
            )
            .ignoresSafeArea()
            .animation(
                .easeInOut(duration: 5)
                .repeatForever(autoreverses: true),
                value: animateBackground
            )



            VStack(spacing: 25) {


                // MARK: Title

                VStack(spacing: 8) {

                    Text("💡 Light It Up")
                        .font(.system(size: 38, weight: .heavy))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    .yellow,
                                    .orange
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )


                    Text("Tap the glowing light ✨")
                        .foregroundColor(.white.opacity(0.7))
                }




                // MARK: Stats Cards

                HStack(spacing: 12) {

                    infoCard(
                        emoji: "⭐",
                        title: "Score",
                        value: "\(vm.score)"
                    )


                    infoCard(
                        emoji: "⏳",
                        title: "Time",
                        value: "\(vm.timeRemaining)"
                    )


                    infoCard(
                        emoji: "🏆",
                        title: "Best",
                        value: "\(vm.highScore)"
                    )
                }




                // MARK: Location

                Label(
                    locationService.displayString,
                    systemImage: "location.fill"
                )
                .font(.caption)
                .foregroundColor(.white.opacity(0.6))





                // MARK: Cards

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

                        .scaleEffect(
                            tappedCard == index ? 0.85 : 1
                        )


                        .onTapGesture {


                            withAnimation(
                                .spring(
                                    response: 0.3,
                                    dampingFraction: 0.5
                                )
                            ) {

                                tappedCard = index
                            }


                            vm.handleTap(index)



                            DispatchQueue.main.asyncAfter(
                                deadline: .now() + 0.15
                            ) {

                                withAnimation {

                                    tappedCard = nil
                                }
                            }
                        }
                    }
                }
                .padding()




                // MARK: Game Over

                if vm.gameOver {


                    VStack(spacing: 18) {


                        Text("🎉 Game Over!")
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)



                        Text("Final Score: \(vm.score)")
                            .font(.headline)
                            .foregroundColor(.yellow)



                        Button {


                            vm.restartGame(
                                sessionStore: sessionStore,
                                locationService: locationService
                            )


                            locationService.recordWhenAvailable(
                                gameName: "Light It Up"
                            )


                        } label: {


                            Text("🔄 Restart")


                                .fontWeight(.bold)

                                .frame(
                                    maxWidth: .infinity
                                )

                                .padding()


                                .background(
                                    LinearGradient(
                                        colors: [
                                            .orange,
                                            .yellow
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )


                                .foregroundColor(.black)

                                .cornerRadius(18)
                        }

                    }

                    .padding()

                    .background(
                        .ultraThinMaterial
                    )

                    .cornerRadius(25)

                    .padding()

                    .transition(
                        .scale
                        .combined(with: .opacity)
                    )
                }


                Spacer()

            }

            .padding()

        }




        .onAppear {


            animateBackground = true


            locationService.startUpdating()


            locationService.recordWhenAvailable(
                gameName: "Light It Up"
            )


            vm.startGame(
                sessionStore: sessionStore,
                locationService: locationService
            )

        }




        .onDisappear {

            vm.stopTimers()

        }
    }




    // MARK: Info Card

    private func infoCard(
        emoji: String,
        title: String,
        value: String
    ) -> some View {


        VStack(spacing: 5) {


            Text(emoji)
                .font(.title2)



            Text(value)
                .font(.headline)
                .foregroundColor(.white)



            Text(title)
                .font(.caption)
                .foregroundColor(
                    .white.opacity(0.7)
                )


        }

        .frame(
            width: 90,
            height: 80
        )

        .background(
            .ultraThinMaterial
        )

        .cornerRadius(20)

    }




    // MARK: Card UI

    private func cardView(
        isActive: Bool
    ) -> some View {


        RoundedRectangle(
            cornerRadius: 22
        )


        .fill(

            isActive

            ?

            LinearGradient(
                colors: [
                    .yellow,
                    .orange
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )


            :

            LinearGradient(
                colors: [
                    Color.gray.opacity(0.4),
                    Color.black.opacity(0.5)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

        )



        .frame(
            height: 150
        )



        .overlay {


            Image(
                systemName:
                    isActive
                ? "lightbulb.fill"
                : "lightbulb"
            )


            .font(
                .system(size: 45)
            )


            .foregroundColor(
                isActive
                ? .white
                : .gray
            )


            .shadow(
                color:
                    isActive
                ? .yellow
                : .clear,

                radius: 20
            )

        }



        .shadow(
            color:
                isActive
            ? .yellow.opacity(0.8)
            : .clear,

            radius: 25
        )


        .animation(
            .spring(),
            value: isActive
        )
    }
}
