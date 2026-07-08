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
    
    
    
    
    var body: some View {
        
        
        VStack(spacing: 30) {
            
            
            Text(
                "Game Complete!"
            )
            .font(.largeTitle)
            .bold()
            
            
            
            ScoreBadge(
                score: score
            )
            
            
            
            ShareLink(
                item:
                    shareText
            ) {
                
                Label(
                    "Share Score",
                    systemImage:
                        "square.and.arrow.up"
                )
                .font(.headline)
            }
            
            
            
            Button {
                
                restartAction()
                
            } label: {
                
                Text(
                    "Play Again"
                )
                .frame(
                    maxWidth: .infinity
                )
            }
            .buttonStyle(
                .borderedProminent
            )
            
            
            
            Button {
                
                dismiss()
                
            } label: {
                
                Text(
                    "Back To Home"
                )
            }
        }
        .padding()
        .onAppear {
            
            saveSession()
        }
    }
    
    
    
    
    private var shareText: String {
        
        """
        I just scored \(score) on \(mode.rawValue) - beat that!
        """
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
