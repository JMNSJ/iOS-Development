import Foundation
import UserNotifications



final class NotificationService {
    
    
    static let shared = NotificationService()
    
    
    private init() {}
    
    
    
    
    // MARK: Request Permission
    
    
    func requestPermission(
        completion: @escaping (Bool) -> Void
    ) {
        
        
        UNUserNotificationCenter
            .current()
            .requestAuthorization(
                options: [
                    .alert,
                    .badge,
                    .sound
                ]
            ) { granted, error in
                
                
                DispatchQueue.main.async {
                    
                    completion(granted)
                }
            }
    }
    
    
    
    
    // MARK: Schedule Daily Challenge
    
    
    func scheduleDailyChallenge(
        hour: Int,
        minute: Int
    ) {
        
        
        removeDailyChallenge()
        
        
        let content =
        UNMutableNotificationContent()
        
        
        content.title =
        "🎮 Daily Challenge"
        
        
        content.body =
        "Can you beat your personal best today?"
        
        
        content.sound =
        .default
        
        
        var date =
        DateComponents()
        
        
        date.hour = hour
        
        date.minute = minute
        
        
        
        let trigger =
        UNCalendarNotificationTrigger(
            dateMatching: date,
            repeats: true
        )
        
        
        
        let request =
        UNNotificationRequest(
            identifier:
                "dailyChallenge",
            content: content,
            trigger: trigger
        )
        
        
        
        UNUserNotificationCenter
            .current()
            .add(request)
    }
    
    
    
    
    // MARK: Remove Notification
    
    
    func removeDailyChallenge() {
        
        UNUserNotificationCenter
            .current()
            .removePendingNotificationRequests(
                withIdentifiers: [
                    "dailyChallenge"
                ]
            )
    }
}
