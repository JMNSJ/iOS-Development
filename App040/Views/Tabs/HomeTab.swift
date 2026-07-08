import SwiftUI


struct HomeTab: View {


    @State private var animateBackground = false



    var body: some View {


        NavigationStack {


            ZStack {


                // MARK: Background

                LinearGradient(
                    colors: [
                        Color.black,
                        Color.indigo.opacity(0.8),
                        Color.purple.opacity(0.6)
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






                VStack(spacing: 30) {



                    Spacer()





                    // MARK: Header


                    VStack(spacing: 10) {



                        Text("🎮 Welcome To Alice In Boardland")

                            .font(
                                .system(
                                    size: 45,
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




                        Text("Choose your challenge 🚀")

                            .foregroundColor(
                                .white.opacity(0.7)
                            )

                    }







                    // MARK: Games



                    NavigationLink {


                        TapFrenzyView()


                    } label: {


                        GameCard(
                            emoji: "⚡",
                            title: "Tap Frenzy",
                            subtitle: "Test your reaction speed",
                            color: .orange
                        )

                    }







                    NavigationLink {


                        LightItUpView()


                    } label: {


                        GameCard(
                            emoji: "💡",
                            title: "Light It Up",
                            subtitle: "Find the glowing light",
                            color: .yellow
                        )

                    }







                    NavigationLink {


                        QuizRushView()


                    } label: {


                        GameCard(
                            emoji: "❓",
                            title: "Quiz Rush",
                            subtitle: "Challenge your knowledge",
                            color: .cyan
                        )

                    }






                    Spacer()



                    Text("🔥 Beat your high score!")

                        .font(.caption)

                        .foregroundColor(
                            .white.opacity(0.5)
                        )


                }

                .padding()

            }


            .navigationTitle("Home")

            .navigationBarTitleDisplayMode(
                .inline
            )

        }


        .onAppear {


            animateBackground = true

        }

    }

}







// MARK: - Game Card


struct GameCard: View {



    let emoji: String

    let title: String

    let subtitle: String

    let color: Color




    var body: some View {



        HStack(spacing: 18) {



            Text(emoji)

                .font(
                    .system(
                        size: 45
                    )
                )






            VStack(
                alignment: .leading,
                spacing: 5
            ) {



                Text(title)

                    .font(.title3)

                    .fontWeight(.bold)

                    .foregroundColor(
                        .white
                    )




                Text(subtitle)

                    .font(.caption)

                    .foregroundColor(
                        .white.opacity(0.7)
                    )

            }






            Spacer()






            Image(
                systemName: "chevron.right"
            )

            .foregroundColor(
                color
            )

            .fontWeight(
                .bold
            )



        }



        .padding()



        .frame(
            maxWidth: .infinity,
            minHeight: 90
        )



        .background(

            RoundedRectangle(
                cornerRadius: 25
            )

            .fill(
                .ultraThinMaterial
            )

        )



        .overlay(

            RoundedRectangle(
                cornerRadius: 25
            )

            .stroke(
                color.opacity(0.6),
                lineWidth: 1.5
            )

        )



        .shadow(
            color: color.opacity(0.4),
            radius: 15
        )

    }

}







#Preview {


    HomeTab()

}
