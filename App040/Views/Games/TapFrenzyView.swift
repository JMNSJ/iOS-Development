import SwiftUI

struct TapFrenzyView: View {
    
    @StateObject private var vm = TapFrenzyVM()
    
    var body: some View {
        
        GeometryReader { geo in
            
            ZStack {
                
                VStack {
                    
                    // Dark Mode Toggle
                    Toggle("Dark Mode", isOn: $vm.isDarkMode)
                        .padding(.horizontal)
                    
                    // Score
                    Text("Score: \(vm.score)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("High Score: \(vm.highScore)")
                        .font(.title3)
                        .foregroundColor(.green)
                    
                    Spacer()
                    
                    // Game Over
                    if vm.gameOver {
                        
                        VStack(spacing: 15) {
                            
                            Text("Game Over!")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                            
                            Text("Good Try! Start Another Game")
                                .font(.headline)
                                .foregroundColor(.purple)
                            
                            Text("Final Score: \(vm.score)")
                                .font(.title3)
                            
                            if vm.score == vm.highScore {
                                Text("🎉 New High Score!")
                                    .foregroundColor(.green)
                            }
                            
                            Button("Let's Play Again!") {
                                vm.restartGame(size: geo.size)
                            }
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                    
                    Spacer()
                    
                    // Timer
                    Text("Time: \(vm.timeRemaining)")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .padding(.bottom, 40)
                }
                
                // Moving Button
                Button {
                    vm.handleTap(in: geo.size)
                } label: {
                    
                    Text("Go")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(width: vm.buttonSize, height: vm.buttonSize)
                        .background(Color.orange.opacity(0.8))
                        .clipShape(Circle())
                }
                .position(vm.buttonPosition)
                .disabled(vm.gameOver)
            }
            .onAppear {
                vm.startGame(size: geo.size)
            }
        }
        .preferredColorScheme(vm.isDarkMode ? .dark : .light)
    }
}

#Preview {
    TapFrenzyView()
}
