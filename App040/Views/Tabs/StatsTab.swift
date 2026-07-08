import SwiftUI


struct StatsTab: View {
    
    
    @EnvironmentObject var sessionStore: SessionStore
    
    
    var body: some View {
        
        
        ScrollView {
            
            
            VStack(spacing: 20) {
                
                
                Text("Statistics")
                    .font(.largeTitle)
                    .bold()
                
                
                
                StatCard(
                    title: "Games Played",
                    value: "\(sessionStore.sessions.count)"
                )
                
                
                
                StatCard(
                    title: "Total Score",
                    value: "\(totalScore)"
                )
                
                
                
                StatCard(
                    title: "Personal Best",
                    value: "\(bestScore)"
                )
                
                
                
                Text("Recent Games")
                    .font(.headline)
                
                
                ForEach(
                    recentGames
                ) { session in
                    
                    HStack {
                        
                        Text(session.mode.rawValue)
                        
                        Spacer()
                        
                        Text("\(session.score)")
                    }
                    .padding()
                    .background(
                        RoundedRectangle(
                            cornerRadius: 12
                        )
                        .fill(
                            Color.gray.opacity(0.15)
                        )
                    )
                }
            }
            .padding()
        }
        .navigationTitle("Stats")
    }
    
    
    
    var totalScore: Int {
        
        sessionStore.sessions
            .reduce(0) {
                $0 + $1.score
            }
    }
    
    
    
    var bestScore: Int {
        
        sessionStore.sessions
            .map {
                $0.score
            }
            .max() ?? 0
    }
    
    
    
    var recentGames: [GameSession] {
        
        sessionStore.sessions
            .sorted {
                $0.timestamp > $1.timestamp
            }
            .prefix(5)
            .map {
                $0
            }
    }
}



struct StatCard: View {
    
    
    let title: String
    
    let value: String
    
    
    var body: some View {
        
        VStack {
            
            Text(title)
                .font(.subheadline)
            
            
            Text(value)
                .font(.largeTitle)
                .bold()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(
                cornerRadius: 20
            )
            .fill(
                Color.blue.opacity(0.15)
            )
        )
    }
}
