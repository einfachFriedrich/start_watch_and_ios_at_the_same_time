//
//  ContentView.swift
//  watchapp Watch App
//
//  Created by Friedrich Vorländer on 09.05.24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: WatchViewModel = WatchViewModel()
    
    var body: some View {
        VStack {
            Text("Counter: \(viewModel.counter)")
                .padding()
            Button(action: {
                viewModel.sendDataMessage(for: .sendCounterToFlutter, data: ["counter": viewModel.counter + 1])
            }) {
                Text("+ by 2")
            }
        }
        
        
    }
}
