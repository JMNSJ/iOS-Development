import SwiftUI

struct HomeView: View {

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {

                Text("Game Hub")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                NavigationLink {
                    TapFrenzy()
                } label: {
                    Text("Tap Frenzy")
                        .frame(width: 220, height: 60)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }

                NavigationLink {
                    LightItUpView()
                } label: {
                    Text("Light It Up")
                        .frame(width: 220, height: 60)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
                
                NavigationLink {
                    QuizRushView()
                } label: {
                    Text("QuizRush")
                        .frame(width: 220, height: 60)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
