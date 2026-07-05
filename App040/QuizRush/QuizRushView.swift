import SwiftUI

struct QuizRushView: View {
    
    @StateObject private var vm = QuizViewModel()
    
    var body: some View {
        ZStack {
            
            if vm.isLoading {
                ProgressView("Loading QuizRush...")
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
                }
            }
        }
        .onAppear {
            vm.startGame()
        }
    }
    
    // MARK: Game View
    var gameView: some View {
        VStack(spacing: 20) {
            
            HStack {
                Text("Score: \(vm.score)")
                Spacer()
                Text("🔥 \(vm.streak)")
            }
            .padding()
            
            if vm.currentIndex < vm.questions.count {
                Text(vm.questions[vm.currentIndex].question)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            
            VStack(spacing: 12) {
                ForEach(vm.options, id: \.self) { option in
                    
                    Button {
                        vm.selectAnswer(option)
                    } label: {
                        Text(option)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(buttonColor(option))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .disabled(vm.selectedAnswer != nil)
                }
            }
            .padding()
            
            Spacer()
        }
    }
    
    // MARK: Result View (NEW)
    var resultView: some View {
        VStack(spacing: 20) {
            
            Text("🎉 Game Finished")
                .font(.largeTitle)
            
            Text("Your Score")
                .font(.headline)
            
            Text("\(vm.score)")
                .font(.system(size: 50, weight: .bold))
                .foregroundColor(.green)
            
            Text("🔥 Final Streak: \(vm.streak)")
                .font(.title3)
            
            Button("Play Again") {
                vm.startGame()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
    
    // MARK: Error View
    func errorView(_ message: String) -> some View {
        VStack(spacing: 16) {
            
            Text("⚠️ \(message)")
                .multilineTextAlignment(.center)
            
            Button("Retry") {
                vm.startGame()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
    
    // MARK: Button Color Logic
    func buttonColor(_ option: String) -> Color {
        
        guard let selected = vm.selectedAnswer else {
            return .blue
        }
        
        let correct = vm.questions[vm.currentIndex].correct_answer
        
        if option == correct {
            return .green
        }
        
        if option == selected {
            return .red
        }
        
        return .gray
    }
}

#Preview {
    QuizRushView()
}
