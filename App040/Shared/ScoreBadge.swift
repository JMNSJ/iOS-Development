import SwiftUI


struct ScoreBadge: View {
    
    
    let score: Int
    
    
    var body: some View {
        
        
        VStack(spacing: 8) {
            
            
            Text("Score")
                .font(.headline)
                .foregroundColor(.secondary)
            
            
            Text(
                "\(score)"
            )
            .font(
                .system(
                    size: 50,
                    weight: .bold
                )
            )
            .foregroundColor(.blue)
        }
        .frame(
            width: 180,
            height: 180
        )
        .background(
            Circle()
                .fill(
                    Color.blue.opacity(0.15)
                )
        )
    }
}
