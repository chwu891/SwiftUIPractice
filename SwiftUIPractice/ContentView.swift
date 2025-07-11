//
//  ContentView.swift
//  SwiftUIPractice
//
//  Created by Chi-Hsien Wu on 7/10/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .task {
            do {
                let posts = try await RemotePostService().fetchAllPosts()
                print("✅ Posts:", posts.map { $0.title })
            } catch {
                print("❌ Error:", error)
            }
        }
    }
}

#Preview {
    ContentView()
}
