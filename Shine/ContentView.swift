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
                    .padding(.leading, 30)
                    .foregroundStyle(Color.gray)
                    .multilineTextAlignment(.leading)
                
                Text("keep up your work!")
                    .multilineTextAlignment(.leading)
                    .padding(.leading,30)
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
                
                TextField("I want to...", text: $viewModel.daily.firstQuestion, axis: .vertical)
                    .padding()
                    
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(5,reservesSpace: true)
                    .onChange(of: viewModel.daily.firstQuestion) {
                        viewModel.saveDailyToDefaults() // Autosave when Step changes
                    }

                
                
                
                Text("Today Tasks")
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading).padding()
                
                // Task text field
                HStack {
                    TextField("One goal for the day", text: $viewModel.daily.task)
                        .padding()
                        .textFieldStyle(.roundedBorder)
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
                    
                    
                        Toggle(isOn: $viewModel.daily.isFinished) {
                        }
                        .padding(.trailing)
                    .toggleStyle(CheckboxToggleStyle())
                    .foregroundColor(.primary)
                }
                
                Text("What's one step you can take today to overcome your fear and start?")
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .padding()
                
                // Feeling text field
                TextField("today I felt...", text: $viewModel.daily.secondQuestion, axis: .vertical)
                    .padding()
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(5,reservesSpace: true)
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
