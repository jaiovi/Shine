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

struct AnimatedProgressBar: View {
    @Binding var progress: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background bar
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 20)
                    .cornerRadius(10)
                
                // Animated filling
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: geometry.size.width * progress, height: 20)
                    .cornerRadius(10)
                    .animation(.easeInOut(duration: 0.5), value: progress) // Animation on progress change
            }
        }
        .padding(5)
    }
}


struct ContentView: View {
    @StateObject private var viewModel = DailyViewModel()
    @State private var progress: CGFloat = 0
    
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
                
                
                Text("\(viewModel.daily.completedSteps)/\(totalSteps)")
                    .padding([.top, .leading], 30.0)
                
                AnimatedProgressBar(progress: $progress)
                    .padding(.leading, 25.0)
                    .frame(height: 20)
            }
            
            ZStack {
                Circle()
                    .stroke(Color.blue, lineWidth: 1)
                    .frame(width: 150, height: 150)
                    .padding()
                Image(systemName: "star.fill")
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
                    .multilineTextAlignment(.leading)
                    .padding()
                GeometryReader { geometry in
                    HStack {
                        TextField("One goal for the day", text: $viewModel.daily.task)
                            .lineLimit(5,reservesSpace: true)
                            .textFieldStyle(.roundedBorder)
                            .padding(.leading, 4.0)
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
                            updateProgress()
                        }
                        .toggleStyle(CheckboxToggleStyle())
                        .frame(width: geometry.size.width * 0.1)                    }
                    .frame(width: geometry.size.width)
 
                }
                .frame(height: 30)
                .padding()

                Text("Did you take a step towards your goal today? How does it make you feel?")
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
            .onAppear {
                updateProgress() // Update progress on appear
            }
            .onChange(of: viewModel.daily.completedSteps) { _ in
                // Update the progress whenever the completed steps change
                withAnimation {
                    progress = CGFloat(viewModel.daily.completedSteps) / CGFloat(totalSteps)
                }
            }
        }
    }
    
    private func updateProgress() {
        viewModel.daily.completedSteps = 0
        if !viewModel.daily.firstQuestion.isEmpty {
            viewModel.daily.completedSteps = 1
            if !viewModel.daily.task.isEmpty && viewModel.daily.isFinished { viewModel.daily.completedSteps = 2
                
                if !viewModel.daily.secondQuestion.isEmpty { viewModel.daily.completedSteps = 3
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
