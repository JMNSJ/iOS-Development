import SwiftUI


struct SettingsTab: View {


    @EnvironmentObject var sessionStore: SessionStore


    @State private var notificationsEnabled = false


    @State private var challengeTime = Date()


    @State private var showResetAlert = false


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





            VStack(spacing: 25) {



                // MARK: Title


                Text("⚙️ Settings")

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






                // MARK: Notification Card


                settingsCard {


                    HStack {


                        Text("🔔")

                            .font(.title)



                        VStack(
                            alignment: .leading
                        ) {


                            Text("Daily Challenge")

                                .foregroundColor(.white)

                                .fontWeight(.bold)



                            Text(
                                "Get a daily game challenge"
                            )

                            .font(.caption)

                            .foregroundColor(
                                .white.opacity(0.7)
                            )

                        }



                        Spacer()



                        Toggle(
                            "",
                            isOn:
                                $notificationsEnabled
                        )

                        .labelsHidden()


                        .onChange(
                            of: notificationsEnabled
                        ) { oldValue, newValue in


                            if newValue {


                                NotificationService
                                    .shared
                                    .requestPermission { _ in }


                            } else {


                                NotificationService
                                    .shared
                                    .removeDailyChallenge()

                            }

                        }

                    }

                }






                // MARK: Time Card


                settingsCard {


                    HStack {


                        Text("⏰")

                            .font(.title)



                        VStack(
                            alignment: .leading
                        ) {


                            Text("Challenge Time")

                                .foregroundColor(.white)

                                .fontWeight(.bold)



                            Text("Choose daily reminder time")

                                .font(.caption)

                                .foregroundColor(
                                    .white.opacity(0.7)
                                )


                        }



                        Spacer()



                        DatePicker(
                            "",
                            selection:
                                $challengeTime,
                            displayedComponents:
                                .hourAndMinute
                        )

                        .labelsHidden()

                    }


                }







                // MARK: Reset


                Button {


                    showResetAlert = true


                } label: {


                    HStack {


                        Text("🗑️")


                        Text("Reset All Stats")

                            .fontWeight(.bold)

                    }


                    .frame(
                        maxWidth: .infinity
                    )


                    .padding()


                    .background(
                        LinearGradient(
                            colors: [
                                .red,
                                .orange
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )


                    .foregroundColor(.white)


                    .cornerRadius(20)

                }




                Spacer()


            }

            .padding()

        }


        .navigationTitle("Settings")

        .navigationBarTitleDisplayMode(
            .inline
        )



        .confirmationDialog(
            "Delete all statistics?",
            isPresented:
                $showResetAlert
        ) {


            Button(
                "Reset",
                role: .destructive
            ) {


                sessionStore.reset()

            }

        }



        .onAppear {


            animateBackground = true

        }

    }







    // MARK: Glass Card


    private func settingsCard<Content: View>(
        @ViewBuilder content: () -> Content
    ) -> some View {


        content()

            .padding()

            .frame(
                maxWidth: .infinity
            )


            .background(
                .ultraThinMaterial
            )


            .cornerRadius(25)


            .overlay(

                RoundedRectangle(
                    cornerRadius: 25
                )

                .stroke(
                    Color.white.opacity(0.15),
                    lineWidth: 1
                )

            )

    }

}
