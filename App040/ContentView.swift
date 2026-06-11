//
//  ContentView.swift
//  App040
//
//  Created by Student1 on 2026-06-06.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            VStack {

                Text("Score: 0")

                Spacer()

                Button("TAP") {

                }

                Spacer()

                Text("Time: 30")
            }
            .padding()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
