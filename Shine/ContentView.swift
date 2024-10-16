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
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 20)
                    .cornerRadius(10)
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: geometry.size.width * progress, height: 20)
                    .cornerRadius(10)
                    .animation(.easeInOut(duration: 0.5), value: progress)
            }
        }
        .padding(5)
    }
}


struct ContentView: View {
    @StateObject private var viewModel = DailyViewModel()
 
    let totalSteps = 3
    
    var body: some View {
        NavigationStack {
            
       
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
                
                AnimatedProgressBar(progress: $viewModel.daily.progress)
                    .padding(.leading, 25.0)
                    .frame(height: 20)

            }
            
            ZStack {
                
                Image(systemName: "star.circle")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color.blue)

                    .padding(.horizontal, 39.0)
                Text("\(viewModel.daily.streak)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .padding()
                
                

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
                    .disabled(viewModel.daily.completedSteps > 1)
                    .disabled( viewModel.daily.completed)
                
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
                            .disabled(viewModel.daily.completedSteps > 2)
                            .disabled( viewModel.daily.completed)
                            
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
                        .disabled(viewModel.daily.completedSteps > 2)
                        .disabled(viewModel.daily.firstQuestion.isEmpty)
                        .disabled( viewModel.daily.completed)
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
                        .disabled(viewModel.daily.task.isEmpty)
                        .disabled(!viewModel.daily.isFinished )
                        .disabled( viewModel.daily.completed == true)
                
            }
            .padding()
            .onAppear {
                updateProgress() // Update progress on appear
            }
            .onChange(of: viewModel.daily.completedSteps) { _ in
                // Update the progress whenever the completed steps change
                withAnimation {
                    viewModel.daily.progress = CGFloat(viewModel.daily.completedSteps) / CGFloat(totalSteps)
                }
            }
            
            if viewModel.daily.completedSteps == 3 && !viewModel.daily.completed {
                Button(action: {
                    // Perform the same actions without navigation
                    viewModel.daily.streak += 1
                    viewModel.daily.completed = true
                    viewModel.saveDailyToDefaults()
                    
                    // Trigger any additional effects you want, like a confetti animation.
                }) {
                    Text("Complete your day")
                        .padding()
                        .bold()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .padding()
            }
            else if viewModel.daily.completed {
                Text("you are done for today")
                                        .padding()
                                        .foregroundColor(.gray)
            }
            
            else {
            Text("Complete all steps to proceed")
                                    .padding()
                                    .foregroundColor(.gray)
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
