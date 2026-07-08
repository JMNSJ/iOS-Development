import SwiftUI


struct HomeTab: View {
    
    
    var body: some View {
        
        VStack(spacing: 25) {
            
            
            Spacer()
            
            
            Text("PlayHub")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            
            Text("Choose a game")
                .foregroundColor(.secondary)
            
            
            
            NavigationLink {
                
                TapFrenzyView()
                
            } label: {
                
                GameButton(
                    title: "Tap Frenzy",
                    icon: "hand.tap.fill"
                )
            }
            
            
            
            NavigationLink {
                
                LightItUpView()
                
            } label: {
                
                GameButton(
                    title: "Light It Up",
                    icon: "lightbulb.fill"
                )
            }
            
            
            
            NavigationLink {
                
                QuizRushView()
                
            } label: {
                
                GameButton(
                    title: "Quiz Rush",
                    icon: "questionmark.circle.fill"
                )
            }
            
            
            
            Spacer()
        }
        .padding()
        .navigationTitle("Home")
    }
}





// MARK: - Reusable Game Button

struct GameButton: View {
    
    
    let title: String
    
    let icon: String
    
    
    
    var body: some View {
        
        
        HStack(spacing: 15) {
            
            
            Image(systemName: icon)
                .font(.title2)
                .frame(width: 30)
            
            
            Text(title)
                .font(.headline)
            
            
            Spacer()
            
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(
            maxWidth: .infinity,
            minHeight: 65
        )
        .background(
            
            RoundedRectangle(
                cornerRadius: 16
            )
            .fill(
                Color.blue.opacity(0.15)
            )
        )
    }
}




#Preview {
    
    NavigationStack {
        HomeTab()
    }
}
