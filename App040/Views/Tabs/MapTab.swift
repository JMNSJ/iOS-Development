import SwiftUI
import MapKit



struct MapTab: View {
    
    
    @EnvironmentObject var sessionStore: SessionStore
    
    @EnvironmentObject var locationService: LocationService
    
    
    @State private var selectedSession: GameSession?
    
    
    @State private var position =
    MapCameraPosition.region(
        
        MKCoordinateRegion(
            center:
                CLLocationCoordinate2D(
                    latitude: 7.8731,
                    longitude: 80.7718
                ),
            
            span:
                MKCoordinateSpan(
                    latitudeDelta: 5,
                    longitudeDelta: 5
                )
        )
    )
    
    
    
    
    var body: some View {
        
        
        Map(
            position: $position
        ) {
            
            
            // MARK: - Saved Game Sessions
            
            ForEach(
                sessionStore.sessions
            ) { session in
                
                
                if let latitude =
                    session.latitude,
                   
                   let longitude =
                    session.longitude {
                    
                    
                    Annotation(
                        session.mode.rawValue,
                        coordinate:
                            CLLocationCoordinate2D(
                                latitude: latitude,
                                longitude: longitude
                            )
                    ) {
                        
                        
                        Button {
                            
                            selectedSession = session
                            
                        } label: {
                            
                            VStack(spacing: 4) {
                                
                                Image(
                                    systemName:
                                        gameIcon(
                                            session.mode
                                        )
                                )
                                .font(.title2)
                                .foregroundColor(.blue)
                                
                                
                                Circle()
                                    .fill(.blue)
                                    .frame(
                                        width: 10,
                                        height: 10
                                    )
                            }
                        }
                    }
                }
            }
            
            
            
            // MARK: - Current User Location
            
            if let location =
                locationService.currentLocation {
                
                
                Annotation(
                    "You",
                    coordinate:
                        location.coordinate
                ) {
                    
                    Image(
                        systemName:
                            "location.fill"
                    )
                    .foregroundColor(.green)
                    .font(.title)
                }
            }
        }
        .navigationTitle("Game Map")
        .onAppear {
            
            locationService.startUpdating()
        }
        .sheet(
            item: $selectedSession
        ) { session in
            
            SessionDetailView(
                session: session
            )
        }
    }
    
    
    
    
    private func gameIcon(
        _ mode: GameMode
    ) -> String {
        
        switch mode {
            
        case .tapFrenzy:
            return "hand.tap.fill"
            
            
        case .lightItUp:
            return "lightbulb.fill"
            
            
        case .quizRush:
            return "questionmark.circle.fill"
        }
    }
}






// MARK: - Session Detail View


struct SessionDetailView: View {
    
    
    let session: GameSession
    
    
    
    var body: some View {
        
        
        VStack(spacing: 20) {
            
            
            Image(
                systemName:
                    gameIcon
            )
            .font(.system(size: 50))
            .foregroundColor(.blue)
            
            
            
            Text(
                session.mode.rawValue
            )
            .font(.largeTitle)
            .bold()
            
            
            
            Text(
                "Score: \(session.score)"
            )
            .font(.title2)
            
            
            
            Divider()
            
            
            
            VStack(spacing: 8) {
                
                
                Text("Completed")
                    .font(.headline)
                
                
                Text(
                    session.timestamp,
                    style: .date
                )
                
                
                Text(
                    session.timestamp,
                    style: .time
                )
            }
            
            
            
            if let latitude =
                session.latitude,
               
               let longitude =
                session.longitude {
                
                
                Divider()
                
                
                Text("Location")
                    .font(.headline)
                
                
                Text(
                    String(
                        format:
                            "%.5f, %.5f",
                        latitude,
                        longitude
                    )
                )
                .font(.caption)
            }
            
            
            
            Spacer()
        }
        .padding()
        .presentationDetents(
            [.medium]
        )
    }
    
    
    
    
    private var gameIcon: String {
        
        switch session.mode {
            
        case .tapFrenzy:
            return "hand.tap.fill"
            
            
        case .lightItUp:
            return "lightbulb.fill"
            
            
        case .quizRush:
            return "questionmark.circle.fill"
        }
    }
}
