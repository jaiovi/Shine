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
                        viewModel.saveDailyToDefaults()
                    }
                
                
                
                
                Text("Today Tasks")
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .padding()
                GeometryReader { geometry in
                    HStack {
                        TextField("One goal for the day", text: $viewModel.daily.task)
                            .lineLimit(5,reservesSpace: true)
                            .textFieldStyle(.roundedBorder)
                            .onChange(of: viewModel.daily.task) {
                                viewModel.saveDailyToDefaults()
                            }
                            .frame(width: geometry.size.width * 0.9)
                        
                        Toggle(isOn: $viewModel.daily.isFinished) {
                            // Boş bırakılabilir
                        }
                        .padding(.trailing)
                        .onChange(of: viewModel.daily.isFinished) {
                            viewModel.saveDailyToDefaults()
                        }
                        .toggleStyle(CheckboxToggleStyle())
                        .frame(width: geometry.size.width * 0.1)                    }
                    .frame(width: geometry.size.width)
                }
                .frame(height: 30)
                .padding()
                
                
                
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
