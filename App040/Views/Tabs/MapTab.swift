import SwiftUI
import MapKit


struct MapTab: View {
    
    
    @EnvironmentObject var sessionStore: SessionStore
    
    
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
            
            
            ForEach(
                sessionStore.sessions
            ) { session in
                
                
                if let lat = session.latitude,
                   let lon = session.longitude {
                    
                    
                    Marker(
                        session.mode.rawValue,
                        coordinate:
                            CLLocationCoordinate2D(
                                latitude: lat,
                                longitude: lon
                            )
                    )
                }
            }
        }
        .navigationTitle("Map")
    }
}
