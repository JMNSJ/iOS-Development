import SwiftUI


struct TapFrenzyView: View {

    @StateObject private var vm = TapFrenzyVM()

    @EnvironmentObject var locationService: LocationService

    @State private var animateBackground = false
    @State private var pulse = false


    var body: some View {


        GeometryReader { geo in


            ZStack {


                // MARK: Background

                LinearGradient(
                    colors: [
                        Color.black,
                        Color.blue.opacity(0.5),
                        Color.purple.opacity(0.7)
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





                if vm.gameOver {



                    ResultView(
                        mode: .tapFrenzy,
                        score: vm.score
                    ) {


                        vm.restartGame(
                            size: geo.size
                        )


                        locationService.recordWhenAvailable(
                            gameName: "Tap Frenzy"
                        )

                    }



                }

                else {


                    VStack(spacing: 25) {


                        // MARK: Title

                        Text("⚡ Tap Frenzy")
                            .font(
                                .system(
                                    size: 38,
                                    weight: .heavy
                                )
                            )
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





                        // MARK: Score Panel

                        HStack(spacing: 15) {


                            infoCard(
                                emoji: "⭐",
                                title: "Score",
                                value: "\(vm.score)"
                            )



                            infoCard(
                                emoji: "🏆",
                                title: "Best",
                                value: "\(vm.highScore)"
                            )



                            infoCard(
                                emoji: "⏳",
                                title: "Time",
                                value: "\(vm.timeRemaining)"
                            )

                        }






                        Label(
                            locationService.displayString,
                            systemImage: "location.fill"
                        )

                        .font(.caption)

                        .foregroundColor(
                            .white.opacity(0.6)
                        )




                        Spacer()




                        Text("Tap the target! 🎯")

                            .font(.headline)

                            .foregroundColor(
                                .white.opacity(0.8)
                            )



                        Spacer()



                    }

                    .padding()





                    // MARK: Tap Button


                    Button {


                        vm.handleTap(
                            in: geo.size
                        )


                    } label: {



                        ZStack {


                            Circle()

                                .fill(
                                    LinearGradient(
                                        colors: [
                                            .orange,
                                            .red
                                        ],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )



                            Circle()

                                .stroke(
                                    .yellow.opacity(0.8),
                                    lineWidth: 5
                                )



                            VStack {


                                Text("🔥")

                                    .font(
                                        .system(
                                            size: 35
                                        )
                                    )



                                Text("GO")

                                    .font(
                                        .title
                                    )

                                    .fontWeight(
                                        .heavy
                                    )

                                    .foregroundColor(
                                        .white
                                    )

                            }

                        }


                        .frame(
                            width: vm.buttonSize,
                            height: vm.buttonSize
                        )



                        .shadow(
                            color: .orange,
                            radius: pulse ? 30 : 10
                        )


                        .scaleEffect(
                            pulse ? 1.08 : 1
                        )


                    }


                    .position(
                        vm.buttonPosition
                    )

                }

            }



            .onAppear {


                animateBackground = true


                pulse = true



                locationService.startUpdating()



                locationService.recordWhenAvailable(
                    gameName: "Tap Frenzy"
                )



                vm.startGame(
                    size: geo.size
                )


            }

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

                .foregroundColor(
                    .white
                )



            Text(title)

                .font(.caption)

                .foregroundColor(
                    .white.opacity(0.7)
                )


        }


        .frame(
            width: 95,
            height: 80
        )


        .background(
            .ultraThinMaterial
        )


        .cornerRadius(20)

    }

}




#Preview {

    NavigationStack {

        TapFrenzyView()

            .environmentObject(
                LocationService()
            )
    }
}
