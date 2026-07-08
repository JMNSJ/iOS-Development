import SwiftUI


struct SettingsTab: View {
    
    
    @EnvironmentObject var sessionStore: SessionStore
    
    
    @State private var notificationsEnabled = false
    
    
    @State private var challengeTime =
    Date()
    
    
    @State private var showResetAlert = false
    
    
    
    var body: some View {
        
        
        Form {
            
            
            Section("Notifications") {
                
                
                Toggle(
                    "Daily Challenge",
                    isOn:
                        $notificationsEnabled
                )
                .onChange(of: notificationsEnabled) { oldValue, newValue in
                    if newValue {
                        NotificationService
                            .shared
                            .requestPermission { _ in }
                    } else {
                        NotificationService
                            .shared
                            .removeDailyChallenge()
                    }
                }
            }
            
            
            
            Section("Challenge Time") {
                
                
                DatePicker(
                    "Time",
                    selection:
                        $challengeTime,
                    displayedComponents:
                        .hourAndMinute
                )
            }
            
            
            
            Section {
                
                
                Button(
                    role: .destructive
                ) {
                    
                    showResetAlert = true
                } label: {
                    
                    Text("Reset All Stats")
                }
            }
        }
        .navigationTitle("Settings")
        .confirmationDialog(
            "Delete all statistics?",
            isPresented:
                $showResetAlert
        ) {
            
            
            Button(
                "Reset",
                role: .destructive
            ) {
                
                sessionStore.reset()
            }
        }
    }
}

