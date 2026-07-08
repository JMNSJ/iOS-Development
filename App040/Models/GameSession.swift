import Combine
import Foundation


struct GameSession: Identifiable, Codable {
    
    let id: UUID
    
    let mode: GameMode
    
    let score: Int
    
    let timestamp: Date
    
    let latitude: Double?
    
    let longitude: Double?
}



class SessionStore: ObservableObject {
    
    
    @Published var sessions: [GameSession] = []
    
    
    private let key = "saved_game_sessions"
    
    
    init() {
        load()
    }
    
    
    
    func add(
        _ session: GameSession
    ) {
        
        sessions.append(session)
        
        save()
    }
    
    
    
    
    func reset() {
        
        sessions.removeAll()
        
        save()
    }
    
    
    
    
    private func save() {
        
        do {
            
            let data = try JSONEncoder()
                .encode(sessions)
            
            UserDefaults.standard
                .set(
                    data,
                    forKey: key
                )
            
        }
        catch {
            
            print(
                "Saving error:",
                error
            )
        }
    }
    
    
    
    
    private func load() {
        
        guard let data =
                UserDefaults.standard
                .data(forKey: key)
        else {
            return
        }
        
        
        do {
            
            sessions =
            try JSONDecoder()
                .decode(
                    [GameSession].self,
                    from: data
                )
            
        }
        catch {
            
            print(
                "Loading error:",
                error
            )
        }
    }
}
