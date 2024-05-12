//
//  ContentView.swift
//  watchapp Watch App
//
//  Created by Friedrich Vorländer on 09.05.24.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel: WatchViewModel = WatchViewModel()
   
    var body: some View {
        VStack {
            Text("Counter: \(viewModel.counter)")
                .padding()
            Button(action: {
                viewModel.sendDataMessage(for: .syncRequest, data: ["counter": viewModel.counter])
                   // viewModel.sendDataMessage(for: .sendDataToFlutter, data: ["counter": viewModel.counter])
            }) {
                Text("+ by 1")
            }
            Toggle("Vibrates", isOn: $viewModel.vibrates)
                .onChange(of: viewModel.vibrates) { oldValue, newValue in
                    viewModel.sendDataMessage(for: .vibratesToFlutter, data: ["vibrates": viewModel.vibrates])
                }
        }
        .onAppear {
            print("Test")
            viewModel.sendDataMessage(for: .syncRequest, data: ["counter": viewModel.counter])
        }
    }
}

#Preview {
    ContentView()
}
