import SwiftUI
import Charts


struct StatsTab: View {
    
    @EnvironmentObject var sessionStore: SessionStore
    
    
    private var statsVM: StatsVM {
        StatsVM(
            sessionStore: sessionStore
        )
    }
    
    
    var body: some View {
        
        List {
            
            Section {
                
                StatCard(
                    title: "Games Played",
                    value: "\(statsVM.totalGames)"
                )
                
                StatCard(
                    title: "Total Score",
                    value: "\(statsVM.totalScore)"
                )
                
                StatCard(
                    title: "Personal Best",
                    value: "\(statsVM.personalBest)"
                )
                
                StatCard(
                    title: "Average Score",
                    value: String(
                        format: "%.1f",
                        statsVM.averageScore
                    )
                )
                
            }
            
            
            Section {
                
                Text("Score By Mode")
                    .font(.title3)
                    .bold()
                
                
                Chart(statsVM.chartData) { item in
                    
                    BarMark(
                        x: .value(
                            "Game",
                            item.mode
                        ),
                        
                        y: .value(
                            "Score",
                            item.score
                        )
                    )
                }
                .frame(height: 200)
                
            }
            
            
            Section {
                
                Text("Personal Bests")
                    .font(.title3)
                    .bold()
                
                
                ForEach(
                    GameMode.allCases,
                    id: \.self
                ) { mode in
                    
                    HStack {
                        
                        Text(mode.rawValue)
                        
                        Spacer()
                        
                        Text(
                            "\(statsVM.bestScore(for: mode))"
                        )
                        .bold()
                    }
                }
                
            }
            
            
            Section {
                
                Text("Recent Games")
                    .font(.title3)
                    .bold()
                
                
                ForEach(
                    statsVM.recentGames
                ) { session in
                    
                    VStack(
                        alignment: .leading,
                        spacing: 8
                    ) {
                        
                        HStack {
                            
                            Text(
                                session.mode.rawValue
                            )
                            .font(.headline)
                            
                            Spacer()
                            
                            Text(
                                "\(session.score)"
                            )
                            .font(.title3)
                            .bold()
                        }
                        
                        
                        Text(
                            session.timestamp,
                            style: .date
                        )
                        .font(.caption)
                    }
                    .padding(.vertical, 8)
                }
                
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Stats")
    }
}




struct StatCard: View {
    
    let title: String
    let value: String
    
    
    var body: some View {
        
        VStack(spacing: 8) {
            
            Text(title)
                .font(.headline)
            
            
            Text(value)
                .font(.largeTitle)
                .bold()
                .minimumScaleFactor(0.5)
                .lineLimit(1)
        }
        .frame(
            maxWidth: .infinity
        )
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
