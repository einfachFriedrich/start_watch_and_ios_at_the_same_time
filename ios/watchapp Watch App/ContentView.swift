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
                
                //notifies the Flutter App that it got increased
                viewModel.sendDataMessage(for: .sendCounterToFlutter, data: ["counter": viewModel.counter])
            }) {
                Text("+ by 1")
            }
        }
        
        
    }
}
