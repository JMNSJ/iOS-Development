import SwiftUI

struct LightItUpView: View {
    
    // MARK: - ViewModel
    @StateObject private var vm = LightItUpViewModel()
    
    // MARK: - Grid
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(spacing: 30) {
            
            Text("Light It Up")
                .font(.largeTitle)
                .bold()
            
            // SCORE SECTION
            HStack {
                VStack(alignment: .leading) {
                    Text("Score: \(vm.score)")
                        .font(.title2)
                    
                    Text("High Score: \(vm.highScore)")
                        .font(.subheadline)
                        .foregroundColor(.green)
                }
                
                Spacer()
                
                Text("Time: \(vm.timeRemaining)s")
                    .font(.title2)
                    .foregroundColor(.red)
            }
            .padding(.horizontal)
            
            // GRID
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(0..<3, id: \.self) { index in
                    CardView(isActive: vm.activeCard == index)
                        .onTapGesture {
                            vm.handleTap(index)
                        }
                }
            }
            .padding()
            
            Spacer()
        }
        .alert("Game Over", isPresented: $vm.gameOver) {
            Button("Play Again") {
                vm.restartGame()
            }
        } message: {
            Text("Final Score: \(vm.score)")
        }
        .onAppear {
            vm.startGame()
        }
        .onDisappear {
            vm.stopTimers()
        }
    }
}
