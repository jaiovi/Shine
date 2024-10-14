//
//  ContentView.swift
//  Shine
//
//  Created by Jesus Sebastian Jaime Oviedo on 14/10/24.
//

import SwiftUI

struct CheckboxToggleStyle: ToggleStyle {
  func makeBody(configuration: Self.Configuration) -> some View {
    HStack {
      configuration.label
      Spacer()
      Image(systemName: configuration.isOn ? "checkmark.square" : "square")
        .resizable()
        .frame(width: 24, height: 24)
        .onTapGesture { configuration.isOn.toggle() }
    }
  }
}

struct ContentView: View {
    // ViewModel handles all logic
    @StateObject private var viewModel = DailyViewModel()
    
    var body: some View {
        
        HStack {
            VStack (alignment: .leading){
                Text("Hello 👋🏼")
                    .padding(.leading, 20.0)
                    .foregroundStyle(Color.gray)
                    .multilineTextAlignment(.leading)
                
                Text("keep up your work!")
                    .multilineTextAlignment(.leading)
                    .padding(.leading,20.0)
            }
            
            Image(systemName: "flame.circle.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(Color.blue)
                .padding(.horizontal, 60.0)
        }
        
        
        .padding(.top, 20)
        
        
        ScrollView {
            VStack (alignment: .leading){
                
                Text("What's one step you can take today to overcome your fear and start?")
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .padding()
                TextField("Step: What are you going to do?", text: $viewModel.daily.firstQuestion)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: viewModel.daily.firstQuestion) {
                        viewModel.saveDailyToDefaults() // Autosave when Step changes
                    }
                Text("Today Tasks")
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading).padding()
                
                // Task text field
                HStack {
                    TextField("Task: One goal for the day", text: $viewModel.daily.task)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: viewModel.daily.task) {
                            viewModel.saveDailyToDefaults() // Autosave when Task changes
                        }
                    
                    // FinishedTask toggle
                   /* Toggle(isOn: $viewModel.daily.isFinished) {
                        
                    }
                    .padding()
                    .onChange(of: viewModel.daily.isFinished) {
                        viewModel.saveDailyToDefaults()
                    }*/
                    
                    HStack {
                        Toggle(isOn: $viewModel.daily.isFinished) {
                            
                        }
                            }
                    .toggleStyle(CheckboxToggleStyle())
                            .foregroundColor(.primary)
                }
                
                Text("What's one step you can take today to overcome your fear and start?")
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .padding()
                
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
}



#Preview {
    ContentView()
}
