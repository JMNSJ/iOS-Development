import SwiftUI
import Charts


struct StatsTab: View {


    @EnvironmentObject var sessionStore: SessionStore


    private var statsVM: StatsVM {

        StatsVM(
            sessionStore: sessionStore
        )
    }


    @State private var animateBackground = false



    var body: some View {


        ZStack {


            // MARK: Background


            LinearGradient(
                colors: [
                    Color.black,
                    Color.indigo.opacity(0.8),
                    Color.purple.opacity(0.6)
                ],

                startPoint:
                    animateBackground
                ? .topLeading
                : .bottomTrailing,

                endPoint:
                    animateBackground
                ? .bottomTrailing
                : .topLeading
            )

            .ignoresSafeArea()


            .animation(
                .easeInOut(duration: 6)
                .repeatForever(
                    autoreverses: true
                ),
                value: animateBackground
            )





            ScrollView {


                VStack(spacing: 25) {




                    Text("📊 Stats")

                        .font(
                            .system(
                                size: 38,
                                weight: .heavy
                            )
                        )

                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    .cyan,
                                    .purple
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )







                    // MARK: Summary Cards


                    LazyVGrid(
                        columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ],
                        spacing: 15
                    ) {


                        StatCard(
                            emoji: "🎮",
                            title: "Games",
                            value:
                                "\(statsVM.totalGames)"
                        )



                        StatCard(
                            emoji: "⭐",
                            title: "Score",
                            value:
                                "\(statsVM.totalScore)"
                        )



                        StatCard(
                            emoji: "🏆",
                            title: "Best",
                            value:
                                "\(statsVM.personalBest)"
                        )



                        StatCard(
                            emoji: "📈",
                            title: "Average",
                            value:
                                String(
                                    format:
                                    "%.1f",
                                    statsVM.averageScore
                                )
                        )


                    }








                    // MARK: Chart


                    statsSection(title: "📊 Score By Mode") {


                        Chart(
                            statsVM.chartData
                        ) { item in


                            BarMark(

                                x:
                                    .value(
                                        "Game",
                                        item.mode
                                    ),


                                y:
                                    .value(
                                        "Score",
                                        item.score
                                    )

                            )

                            .foregroundStyle(
                                .cyan
                            )

                        }

                        .frame(
                            height: 220
                        )

                    }








                    // MARK: Personal Best


                    statsSection(
                        title:
                            "🏆 Personal Bests"
                    ) {



                        ForEach(
                            GameMode.allCases,
                            id: \.self
                        ) { mode in


                            HStack {


                                Text(
                                    gameEmoji(mode)
                                )


                                Text(
                                    mode.rawValue
                                )

                                .foregroundColor(
                                    .white
                                )


                                Spacer()



                                Text(
                                    "\(statsVM.bestScore(for: mode))"
                                )

                                .bold()

                                .foregroundColor(
                                    .yellow
                                )


                            }


                            .padding(.vertical, 8)

                        }

                    }









                    // MARK: Recent Games


                    statsSection(
                        title:
                            "🎮 Recent Games"
                    ) {



                        ForEach(
                            statsVM.recentGames
                        ) { session in


                            HStack {


                                VStack(
                                    alignment:
                                        .leading
                                ) {


                                    Text(
                                        gameEmoji(
                                            session.mode
                                        )
                                        +
                                        " "
                                        +
                                        session.mode.rawValue
                                    )

                                    .font(
                                        .headline
                                    )

                                    .foregroundColor(
                                        .white
                                    )



                                    Text(
                                        session.timestamp,
                                        style: .date
                                    )

                                    .font(
                                        .caption
                                    )

                                    .foregroundColor(
                                        .white.opacity(0.6)
                                    )

                                }



                                Spacer()



                                Text(
                                    "\(session.score)"
                                )

                                .font(
                                    .title3
                                )

                                .bold()

                                .foregroundColor(
                                    .yellow
                                )

                            }


                            .padding()

                            .background(
                                .ultraThinMaterial
                            )

                            .cornerRadius(18)


                        }


                    }




                }

                .padding()

            }

        }



        .navigationTitle(
            "Stats"
        )

        .navigationBarTitleDisplayMode(
            .inline
        )



        .onAppear {

            animateBackground = true

        }

    }








    // MARK: Section Container


    private func statsSection<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {


        VStack(
            alignment: .leading,
            spacing: 15
        ) {


            Text(title)

                .font(
                    .title3
                )

                .bold()

                .foregroundColor(
                    .white
                )



            content()

        }

        .padding()

        .frame(
            maxWidth: .infinity
        )

        .background(
            .ultraThinMaterial
        )

        .cornerRadius(25)

    }







    private func gameEmoji(
        _ mode: GameMode
    ) -> String {


        switch mode {


        case .tapFrenzy:

            return "⚡"



        case .lightItUp:

            return "💡"



        case .quizRush:

            return "❓"

        }

    }

}







struct StatCard: View {


    let emoji: String

    let title: String

    let value: String





    var body: some View {


        VStack(spacing: 8) {


            Text(emoji)

                .font(
                    .title
                )



            Text(title)

                .font(
                    .headline
                )

                .foregroundColor(
                    .white.opacity(0.7)
                )



            Text(value)

                .font(
                    .largeTitle
                )

                .bold()

                .minimumScaleFactor(0.5)

                .lineLimit(1)

                .foregroundColor(
                    .white
                )

        }



        .frame(
            maxWidth: .infinity
        )


        .padding()


        .background(
            .ultraThinMaterial
        )


        .cornerRadius(
            20
        )


        .overlay(

            RoundedRectangle(
                cornerRadius: 20
            )

            .stroke(
                Color.white.opacity(0.15),
                lineWidth: 1
            )

        )

    }

}
