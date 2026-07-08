import SwiftUI


struct HomeTab: View {
    
    
    var body: some View {
        
        VStack(spacing: 25) {
            
            
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



struct GameButton: View {
    
    
    let title: String
    
    let icon: String
    
    
    var body: some View {
        
        
        HStack {
            
            Image(systemName: icon)
                .font(.title2)
            
            
            Text(title)
                .font(.headline)
            
            
            Spacer()
            
            
            Image(systemName: "chevron.right")
        }
        .padding()
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
