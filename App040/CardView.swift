import SwiftUI

struct CardView: View {
    
    let isActive: Bool
    
    var body: some View {
        
        RoundedRectangle(cornerRadius: 20)
            .fill(
                isActive
                ? Color.yellow
                : Color.gray.opacity(0.3)
            )
            .frame(height: 150)
            .overlay {
                
                Image(systemName:
                        isActive
                      ? "lightbulb.fill"
                      : "lightbulb")
                    .font(.system(size: 40))
                    .foregroundColor(
                        isActive ? .orange : .gray
                    )
            }
            .shadow(radius: 5)
    }
}
