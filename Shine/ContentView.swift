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
            TextField("Step: What are you going to do?", text: $viewModel.daily.firstQuestion)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: viewModel.daily.firstQuestion) {
                    viewModel.saveDailyToDefaults() // Autosave when Step changes
                }
            
            // Task text field
            TextField("Task: One goal for the day", text: $viewModel.daily.task)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: viewModel.daily.task) {
                    viewModel.saveDailyToDefaults() // Autosave when Task changes
                }
            
            // FinishedTask toggle
            Toggle(isOn: $viewModel.daily.isFinished) {
                Text("Finished Task")
            }
            .padding()
            .onChange(of: viewModel.daily.isFinished) {
                viewModel.saveDailyToDefaults() // Autosave when FinishedTask changes
            }
            
            // Feeling text field
            TextField("Feeling: How did it feel?", text: $viewModel.daily.secondQuestion)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: viewModel.daily.secondQuestion) {
                    viewModel.saveDailyToDefaults() // Autosave when Feeling changes
                }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
