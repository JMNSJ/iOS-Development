import SwiftUI

struct QuizRushView: View {

    @StateObject private var vm = QuizRushVM()

    @EnvironmentObject var sessionStore: SessionStore
    @EnvironmentObject var locationService: LocationService

    @State private var animateBackground = false
    @State private var pressedOption: String?



    var body: some View {

        ZStack {


            // MARK: Background

            LinearGradient(
                colors: [
                    .black,
                    .indigo.opacity(0.8),
                    .purple.opacity(0.6)
                ],
                startPoint: animateBackground ? .topLeading : .bottomTrailing,
                endPoint: animateBackground ? .bottomTrailing : .topLeading
            )
            .ignoresSafeArea()
            .animation(
                .easeInOut(duration: 6)
                .repeatForever(autoreverses: true),
                value: animateBackground
            )




            if vm.isLoading {

                ProgressView("Loading QuizRush... 🎮")
                    .tint(.yellow)
                    .foregroundColor(.white)

            }


            else if let error = vm.errorMessage {

                errorView(error)

            }


            else {


                switch vm.gameState {


                case .playing:

                    gameView


                case .finished:

                    resultView
                        .onAppear {

                            vm.finishGame(
                                sessionStore: sessionStore,
                                locationService: locationService
                            )
                        }
                }
            }

        }


        .onAppear {


            animateBackground = true


            locationService.startUpdating()


            locationService.recordWhenAvailable(
                gameName: "Quiz Rush"
            )


            vm.startGame()

        }


        .onDisappear {

            vm.cancelPendingWork()

        }
    }






    // MARK: Game View

    private var gameView: some View {


        VStack(spacing: 25) {


            Text("❓ Quiz Rush")
                .font(.system(size: 38, weight: .heavy))
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            .cyan,
                            .blue
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )




            // MARK: Score

            HStack(spacing: 15) {


                statCard(
                    emoji: "⭐",
                    title: "Score",
                    value: "\(vm.score)"
                )


                statCard(
                    emoji: "🔥",
                    title: "Streak",
                    value: "\(vm.streak)"
                )

            }




            Label(
                locationService.displayString,
                systemImage: "location.fill"
            )
            .font(.caption)
            .foregroundColor(.white.opacity(0.6))






            if vm.currentIndex < vm.questions.count {


                VStack(spacing: 15) {


                    Text(
                        "Question \(vm.currentIndex + 1)/\(vm.questions.count)"
                    )
                    .font(.caption)
                    .foregroundColor(.yellow)



                    Text(
                        vm.questions[vm.currentIndex].question
                    )

                    .font(.title3)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)


                    .padding()

                }

                .frame(maxWidth: .infinity)

                .background(
                    .ultraThinMaterial
                )

                .cornerRadius(25)

                .padding(.horizontal)



            }






            VStack(spacing: 14) {


                ForEach(vm.options, id: \.self) { option in



                    Button {


                        withAnimation(
                            .spring()
                        ) {

                            pressedOption = option

                        }


                        vm.selectAnswer(option)



                    } label: {


                        HStack {


                            Text("🔹")


                            Text(option)
                                .multilineTextAlignment(.leading)


                            Spacer()


                        }

                        .padding()

                        .frame(
                            maxWidth: .infinity
                        )


                        .background(
                            buttonColor(option)
                        )


                        .foregroundColor(.white)


                        .cornerRadius(18)


                    }

                    .disabled(
                        vm.selectedAnswer != nil
                    )

                    .scaleEffect(
                        pressedOption == option ? 0.95 : 1
                    )

                }

            }

            .padding(.horizontal)



            Spacer()

        }

        .padding()

    }








    // MARK: Result View

    private var resultView: some View {


        VStack(spacing: 22) {


            Text("🎉 Quiz Completed!")

                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)



            Text("Final Score")

                .foregroundColor(.white.opacity(0.7))



            Text("\(vm.score)")

                .font(
                    .system(
                        size: 60,
                        weight: .heavy
                    )
                )

                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            .yellow,
                            .orange
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )



            Text("🔥 Final Streak: \(vm.streak)")

                .font(.title3)
                .foregroundColor(.white)




            Button {


                vm.startGame()


                locationService.recordWhenAvailable(
                    gameName: "Quiz Rush"
                )


            } label: {


                Text("🚀 Play Again")


                    .fontWeight(.bold)

                    .frame(
                        maxWidth: .infinity
                    )

                    .padding()


                    .background(
                        LinearGradient(
                            colors: [
                                .blue,
                                .cyan
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )


                    .foregroundColor(.white)

                    .cornerRadius(18)

            }


            .padding(.horizontal)


        }

        .padding()

        .background(
            .ultraThinMaterial
        )

        .cornerRadius(30)

        .padding()

    }







    // MARK: Error View

    private func errorView(
        _ message: String
    ) -> some View {


        VStack(spacing: 20) {


            Text("⚠️")
                .font(.system(size: 50))


            Text(message)

                .multilineTextAlignment(.center)

                .foregroundColor(.white)




            Button {


                locationService.startUpdating()


                locationService.recordWhenAvailable(
                    gameName: "Quiz Rush"
                )


                vm.startGame()



            } label: {


                Text("🔄 Retry")


                    .padding()

                    .frame(
                        width: 150
                    )

                    .background(
                        .blue
                    )

                    .foregroundColor(.white)

                    .cornerRadius(15)

            }


        }

        .padding()

    }







    // MARK: Stat Card

    private func statCard(
        emoji: String,
        title: String,
        value: String
    ) -> some View {


        VStack {


            Text(emoji)
                .font(.title2)


            Text(value)
                .font(.headline)
                .foregroundColor(.white)


            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))

        }

        .frame(
            width: 120,
            height: 80
        )

        .background(
            .ultraThinMaterial
        )

        .cornerRadius(20)

    }








    // MARK: Button Color

    private func buttonColor(
        _ option: String
    ) -> Color {


        guard let selected = vm.selectedAnswer else {

            return Color.blue.opacity(0.7)

        }


        guard vm.currentIndex < vm.questions.count else {

            return .gray

        }



        let correct =
        vm.questions[vm.currentIndex]
            .correct_answer



        if option == correct {

            return .green

        }


        if option == selected {

            return .red

        }


        return .gray.opacity(0.6)

    }

}
