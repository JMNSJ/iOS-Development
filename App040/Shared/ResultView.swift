import SwiftUI


struct ResultView: View {
    
    
    let mode: GameMode
    
    let score: Int
    
    let restartAction: () -> Void
    
    
    @EnvironmentObject var sessionStore: SessionStore
    @EnvironmentObject var locationService: LocationService
    
    
    @Environment(\.dismiss)
    private var dismiss
    
    
    @State private var saved = false
    @State private var animate = false
    
    
    
    
    var body: some View {
        
        
        ZStack {
            
            
            // MARK: Background
            
            LinearGradient(
                colors: [
                    Color.black,
                    Color.indigo.opacity(0.8),
                    Color.purple.opacity(0.7)
                ],
                startPoint: animate ? .topLeading : .bottomTrailing,
                endPoint: animate ? .bottomTrailing : .topLeading
            )
            .ignoresSafeArea()
            .animation(
                .easeInOut(duration: 6)
                .repeatForever(
                    autoreverses: true
                ),
                value: animate
            )
            
            
            
            
            VStack(spacing: 25) {
                
                
                Text("🎉")
                    .font(.system(size: 70))
                
                
                Text("Game Complete!")
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
                
                
                
                Text(gameEmoji)
                    .font(.system(size: 45))
                
                
                
                Text(mode.rawValue)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                
                
                
                
                // MARK: Score Card
                
                VStack(spacing: 10) {
                    
                    Text("⭐ Final Score")
                        .font(.headline)
                        .foregroundColor(
                            .white.opacity(0.7)
                        )
                    
                    
                    Text("\(score)")
                        .font(
                            .system(
                                size: 60,
                                weight: .heavy
                            )
                        )
                        .foregroundColor(.yellow)
                    
                }
                .frame(
                    maxWidth: .infinity
                )
                .padding()
                .background(
                    .ultraThinMaterial
                )
                .cornerRadius(30)
                .overlay(
                    RoundedRectangle(
                        cornerRadius: 30
                    )
                    .stroke(
                        Color.yellow.opacity(0.4),
                        lineWidth: 2
                    )
                )
                
                
                
                
                // MARK: Share Button
                
                ShareLink(
                    item: shareText
                ) {
                    
                    HStack {
                        
                        Image(
                            systemName:
                                "square.and.arrow.up"
                        )
                        
                        Text("Share Score")
                            .fontWeight(.bold)
                        
                    }
                    .frame(
                        maxWidth: .infinity
                    )
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [
                                .cyan,
                                .blue
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .foregroundColor(.white)
                    .cornerRadius(18)
                    
                }
                
                
                
                
                // MARK: Restart Button
                
                Button {
                    
                    restartAction()
                    
                } label: {
                    
                    HStack {
                        
                        Text("🔄")
                        
                        Text("Play Again")
                            .fontWeight(.bold)
                    }
                    .frame(
                        maxWidth: .infinity
                    )
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [
                                .orange,
                                .yellow
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .foregroundColor(.black)
                    .cornerRadius(18)
                    
                }
                
                
                
                
                Button {
                    
                    dismiss()
                    
                } label: {
                    
                    Text("🏠 Back To Home")
                        .foregroundColor(
                            .white.opacity(0.8)
                        )
                }
                
            }
            .padding()
            
        }
        
        .onAppear {
            
            animate = true
            
            saveSession()
        }
    }
    
    
    
    
    private var shareText: String {
        
        """
        I just scored \(score) on \(mode.rawValue) - beat that!
        """
    }
    
    
    
    
    private var gameEmoji: String {
        
        switch mode {
            
        case .tapFrenzy:
            return "⚡"
            
        case .lightItUp:
            return "💡"
            
        case .quizRush:
            return "❓"
        }
    }
    
    
    
    
    private func saveSession() {
        
        
        guard !saved else {
            return
        }
        
        
        let session =
        GameSession(
            id: UUID(),
            mode: mode,
            score: score,
            timestamp: Date(),
            latitude:
                locationService.latitude,
            longitude:
                locationService.longitude
        )
        
        
        sessionStore.add(
            session
        )
        
        
        saved = true
    }
}
