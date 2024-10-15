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
    @State var completedSteps = 0
    let totalSteps = 3
    
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
                
                Text("\(completedSteps)/\(totalSteps)")
                                       .padding([.top, .leading], 30.0)
                
                ProgressView(value: Float(completedSteps), total: Float(totalSteps))
                    .padding(.leading, 30.0)
                    .frame(height: 20)

            }
            
            ZStack {
                Image(systemName: "star.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color.blue)
                    .padding(.horizontal, 60.0)
            }
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
                        updateProgress()
                    }

                
                
                
                Text("Today Tasks")
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading).padding()
                
                // Task text field
                
                HStack {
                    TextField("One goal for the day", text: $viewModel.daily.task)
                        .padding([.top, .leading, .bottom])
                        .textFieldStyle(.roundedBorder)
                        .onChange(of: viewModel.daily.task) {
                            viewModel.saveDailyToDefaults()
                        }
                
                                Toggle(isOn: $viewModel.daily.isFinished) {
                                }.padding(.trailing)
                                    .onChange(of: viewModel.daily.isFinished) {
                                                viewModel.saveDailyToDefaults()
                                        updateProgress()
                                                            }
                                                    .toggleStyle(CheckboxToggleStyle())
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
                        viewModel.saveDailyToDefaults()
                        updateProgress()
                    }
            }
            .padding()
            
        }
    }
    
    private func updateProgress() {
            completedSteps = 0
            if !viewModel.daily.firstQuestion.isEmpty { completedSteps += 1 }
            if !viewModel.daily.task.isEmpty && viewModel.daily.isFinished { completedSteps += 1 }
            if !viewModel.daily.secondQuestion.isEmpty { completedSteps += 1 }
        }
}



#Preview {
    ContentView()
}
