//
//  ContentView.swift
//  watchapp Watch App
//
//  Created by Friedrich Vorländer on 09.05.24.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel: WatchViewModel = WatchViewModel()
    @State private var firstAppStart = true
   
    var body: some View {
        VStack {
            Text("Counter: \(viewModel.counter)")
                .padding()
            Button(action: {
                if firstAppStart{
                    viewModel.sendDataMessage(for: .syncRequest, data: ["counter": viewModel.counter])
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5){
                        viewModel.sendDataMessage(for: .sendDataToFlutter, data: ["counter": viewModel.counter])
                    }
                    firstAppStart = false
                } else{
                    viewModel.sendDataMessage(for: .sendDataToFlutter, data: ["counter": viewModel.counter])
                }
            }) {
                Text("+ by 1")
            }
        }
        .task {
            viewModel.sendDataMessage(for: .syncRequest, data: ["counter": viewModel.counter])
        }
    }
}
