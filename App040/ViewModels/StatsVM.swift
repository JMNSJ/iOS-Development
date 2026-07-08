import SwiftUI
import Foundation
import Combine


@MainActor
final class StatsVM: ObservableObject {
    
    
    private let sessionStore: SessionStore
    
    
    init(sessionStore: SessionStore) {
        self.sessionStore = sessionStore
    }
    
    
    
    // MARK: - Sessions
    
    var sessions: [GameSession] {
        sessionStore.sessions
    }
    
    
    
    // MARK: - Total Games
    
    var totalGames: Int {
        sessions.count
    }
    
    
    
    // MARK: - Total Score
    
    var totalScore: Int {
        
        sessions.reduce(0) { total, session in
            total + session.score
        }
    }
    
    
    
    // MARK: - Personal Best
    
    var personalBest: Int {
        
        sessions
            .map {
                $0.score
            }
            .max() ?? 0
    }
    
    
    
    // MARK: - Average Score
    
    var averageScore: Double {
        
        guard !sessions.isEmpty else {
            return 0
        }
        
        
        return Double(totalScore)
        /
        Double(totalGames)
    }
    
    
    
    // MARK: - Recent Games
    
    var recentGames: [GameSession] {
        
        Array(
            sessions
                .sorted {
                    $0.timestamp > $1.timestamp
                }
                .prefix(5)
        )
    }
    
    
    
    // MARK: - Best Score Per Mode
    
    func bestScore(
        for mode: GameMode
    ) -> Int {
        
        sessions
            .filter {
                $0.mode == mode
            }
            .map {
                $0.score
            }
            .max() ?? 0
    }
    
    
    
    // MARK: - Chart Data
    
    var chartData: [ChartData] {
        
        GameMode.allCases.map { mode in
            
            ChartData(
                mode: mode.rawValue,
                score: totalScore(for: mode)
            )
        }
    }
    
    
    
    private func totalScore(
        for mode: GameMode
    ) -> Int {
        
        sessions
            .filter {
                $0.mode == mode
            }
            .reduce(0) {
                $0 + $1.score
            }
    }
}



struct ChartData: Identifiable {
    
    let id = UUID()
    
    let mode: String
    
    let score: Int
}

