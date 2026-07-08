import SwiftUI

@main
struct PlayHubApp: App {
    
    @StateObject private var sessions = SessionStore()
    @StateObject private var locationService = LocationService()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                
                NavigationStack {
                    HomeTab()
                }
                .tabItem {
                    Label(
                        "Home",
                        systemImage: "gamecontroller.fill"
                    )
                }
                
                
                NavigationStack {
                    StatsTab()
                }
                .tabItem {
                    Label(
                        "Stats",
                        systemImage: "chart.bar.fill"
                    )
                }
                
                
                NavigationStack {
                    MapTab()
                }
                .tabItem {
                    Label(
                        "Map",
                        systemImage: "map.fill"
                    )
                }
                
                
                NavigationStack {
                    SettingsTab()
                }
                .tabItem {
                    Label(
                        "Settings",
                        systemImage: "gearshape.fill"
                    )
                }
            }
            .environmentObject(sessions)
            .environmentObject(locationService)
        }
    }
}
