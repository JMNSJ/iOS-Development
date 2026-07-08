import SwiftUI

struct TapFrenzyView: View {

    @StateObject private var vm = TapFrenzyVM()

    var body: some View {

        GeometryReader { geo in

            ZStack {

                if vm.gameOver {

                    ResultView(
                        mode: .tapFrenzy,
                        score: vm.score
                    ) {
                        vm.restartGame(size: geo.size)
                    }

                } else {

                    VStack {

                        Toggle("Dark Mode", isOn: $vm.isDarkMode)
                            .padding(.horizontal)

                        Text("Score: \(vm.score)")
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        Text("High Score: \(vm.highScore)")
                            .font(.title3)
                            .foregroundColor(.green)

                        Spacer()

                        Text("Time: \(vm.timeRemaining)")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                            .padding(.bottom, 40)
                    }

                    Button {

                        vm.handleTap(in: geo.size)

                    } label: {

                        Text("Go")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(
                                width: vm.buttonSize,
                                height: vm.buttonSize
                            )
                            .background(
                                Color.orange.opacity(0.8)
                            )
                            .clipShape(Circle())
                    }
                    .position(vm.buttonPosition)
                }
            }
            .onAppear {

                vm.startGame(size: geo.size)
            }
        }
        .preferredColorScheme(
            vm.isDarkMode ? .dark : .light
        )
    }
}

#Preview {
    NavigationStack {
        TapFrenzyView()
    }
}
