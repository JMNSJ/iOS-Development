import SwiftUI

struct QuizRushView: View {
    
    @StateObject private var vm = QuizViewModel()
    
    var body: some View {
        ZStack {
            
            if vm.isLoading {
                loadingView
            }
            else if let error = vm.errorMessage {
                errorView(error)
            }
            else {
                gameView
            }
        }
        .onAppear {
            vm.startGame()
        }
    }
    
    // MARK: Game UI
    var gameView: some View {
        VStack(spacing: 20) {
            
            // Score + Streak
            HStack {
                Text("Score: \(vm.score)")
                Spacer()
                Text("🔥 \(vm.streak)")
            }
            .padding()
            .font(.headline)
            
            // Question
            if vm.currentIndex < vm.questions.count {
                Text(vm.questions[vm.currentIndex].question)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            
            // Options
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
                            .scaleEffect(vm.selectedAnswer == option ? 1.05 : 1.0)
                            .animation(.spring(), value: vm.selectedAnswer)
                    }
                    .disabled(vm.selectedAnswer != nil)
                }
            }
            .padding()
            
            Spacer()
        }
        .animation(.easeInOut, value: vm.currentIndex)
    }
    
    // MARK: Loading View
    var loadingView: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading QuizRush...")
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
    
    // MARK: Button Colors
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
