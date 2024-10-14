//
//  ContentView.swift
//  Shine
//
//  Created by Jesus Sebastian Jaime Oviedo on 14/10/24.
//

import SwiftUI

struct ContentView: View {
    // ViewModel handles all logic
    @StateObject private var viewModel = DailyViewModel()
    
    var body: some View {
        VStack {
            Text("Daily Plan")
                .font(.largeTitle)
            
            // Step text field
            TextField("Step: What are you going to do?", text: $viewModel.daily.Question1)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: viewModel.daily.Question1) {
                    viewModel.saveDailyToDefaults() // Autosave when Step changes
                }
            
            // Task text field
            TextField("Task: One goal for the day", text: $viewModel.daily.Task)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: viewModel.daily.Task) {
                    viewModel.saveDailyToDefaults() // Autosave when Task changes
                }
            
            // FinishedTask toggle
            Toggle(isOn: $viewModel.daily.FinishedTask) {
                Text("Finished Task")
            }
            .padding()
            .onChange(of: viewModel.daily.FinishedTask) {
                viewModel.saveDailyToDefaults() // Autosave when FinishedTask changes
            }
            
            // Feeling text field
            TextField("Feeling: How did it feel?", text: $viewModel.daily.Question2)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: viewModel.daily.Question2) {
                    viewModel.saveDailyToDefaults() // Autosave when Feeling changes
                }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
