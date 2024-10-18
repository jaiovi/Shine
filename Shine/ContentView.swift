//
//  ContentView.swift
//  Shine
//
//  Created by Jesus Sebastian Jaime Oviedo on 14/10/24.
//

import SwiftUI
import ConfettiSwiftUI

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

struct ConfettiParticleEmitter: View {
    let confettiColors: [Color] = [.red, .green, .blue, .yellow, .orange, .purple]
    @State private var particles: [ConfettiParticle] = []
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(particles) { particle in
                    ConfettiParticleView(particle: particle)
                        .position(particle.position)
                }
            }
            .onAppear {
                emitParticles(in: geometry.size)
            }
        }
        .allowsHitTesting(false)
    }
    
    func emitParticles(in size: CGSize) {
        for _ in 0..<30 {
            let randomX = CGFloat.random(in: 0...size.width)
            let randomDelay = Double.random(in: 0...0.3)
            
            let newParticle = ConfettiParticle(id: UUID(), position: CGPoint(x: randomX, y: -20))
            
            DispatchQueue.main.asyncAfter(deadline: .now() + randomDelay) {
                withAnimation(.easeIn(duration: 1.5)) {
                    var movedParticle = newParticle
                    movedParticle.position.y = size.height + 20
                    particles.append(movedParticle)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        particles.removeAll(where: { $0.id == movedParticle.id })
                    }
                }
            }
        }
    }
}


struct ConfettiParticle: Identifiable {
    let id: UUID
    var position: CGPoint
}

struct ConfettiParticleView: View {
    let particle: ConfettiParticle
    let colors: [Color] = [.red, .green, .blue, .yellow, .orange, .purple]
    
    var body: some View {
        Circle()
            .fill(colors.randomElement()!)
            .frame(width: 10, height: 10)
    }
}

struct ContentView: View {
    @StateObject private var viewModel = DailyViewModel()
    @State private var confettiCounter = 0
    @State private var showCongratsMessage = false
    @State private var opacity: Double = 1.0
    
    let totalSteps = 3
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    // Existing header and progress bar
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Hello 👋🏼")
                                .padding(.leading, 30)
                                .foregroundStyle(Color.gray)
                                .multilineTextAlignment(.leading)
                            
                            Text("keep up your work!")
                                .multilineTextAlignment(.leading)
                                .padding(.leading, 30)
                            
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
                        VStack(alignment: .leading) {
                            Text("What do you want to accomplish today, and what has held you back from starting?")
                                .fontWeight(.bold)
                                .multilineTextAlignment(.leading)
                                .padding()
                            
                            TextField("I want to...", text: $viewModel.daily.firstQuestion, axis: .vertical)
                                .padding()
                                .textFieldStyle(.roundedBorder)
                                .lineLimit(5, reservesSpace: true)
                                .onChange(of: viewModel.daily.firstQuestion) {
                                    viewModel.saveDailyToDefaults()
                                    updateProgress()
                                }
                                .disabled(viewModel.daily.completedSteps > 1 || viewModel.daily.completed)
                            
                            Text("Today Tasks")
                                .fontWeight(.bold)
                                .multilineTextAlignment(.leading)
                                .padding()
                            
                            GeometryReader { geometry in
                                HStack {
                                    TextField("One goal for the day", text: $viewModel.daily.task)
                                        .lineLimit(5, reservesSpace: true)
                                        .textFieldStyle(.roundedBorder)
                                        .padding(.leading, 4.0)
                                        .disabled(viewModel.daily.completedSteps > 2 || viewModel.daily.completed)
                                        .onChange(of: viewModel.daily.task) {
                                            viewModel.saveDailyToDefaults()
                                        }
                                        .frame(width: geometry.size.width * 0.9)
                                    
                                    Toggle(isOn: $viewModel.daily.isFinished) {
                                        // Empty label
                                    }
                                    .padding(.trailing)
                                    .onChange(of: viewModel.daily.isFinished) {
                                        viewModel.saveDailyToDefaults()
                                        updateProgress()
                                    }
                                    .disabled(viewModel.daily.completedSteps > 2 || viewModel.daily.firstQuestion.isEmpty || viewModel.daily.completed)
                                    .toggleStyle(CheckboxToggleStyle())
                                    .frame(width: geometry.size.width * 0.1)
                                }
                                .frame(width: geometry.size.width)
                            }
                            .frame(height: 30)
                            .padding()
                            
                            Text("Did you take a step towards your goal today? How does it make you feel?")
                                .fontWeight(.bold)
                                .multilineTextAlignment(.leading)
                                .padding()
                            
                            TextField("today I felt...", text: $viewModel.daily.secondQuestion, axis: .vertical)
                                .padding()
                                .textFieldStyle(.roundedBorder)
                                .lineLimit(5, reservesSpace: true)
                                .onChange(of: viewModel.daily.secondQuestion) {
                                    viewModel.saveDailyToDefaults()
                                    updateProgress()
                                }
                                .disabled(viewModel.daily.task.isEmpty || !viewModel.daily.isFinished || viewModel.daily.completed)
                        }
                        .padding()
                        .onAppear { updateProgress() }
                        .onChange(of: viewModel.daily.completedSteps) { _ in
                            withAnimation {
                                viewModel.daily.progress = CGFloat(viewModel.daily.completedSteps) / CGFloat(totalSteps)
                            }
                        }
                        
                        if viewModel.daily.completedSteps == 3 && !viewModel.daily.completed {
                            Button(action: {
                                viewModel.daily.streak += 1
                                viewModel.daily.completed = true
                                viewModel.saveDailyToDefaults()
                                
                                confettiCounter += 1
                                showCongratsMessage = true
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                                    withAnimation {
                                        showCongratsMessage = false
                                        opacity = 0.0
                                    }
                                }
                                
                            }) {
                                Text("Complete your day")
                                    .padding()
                                    .bold()
                                    .foregroundColor(.white)
                                    .background(Color.blue)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                            }
                            .padding()
                        } else if viewModel.daily.completed {
                            Text("You are done for today, see you tomorrow")
                                .padding()
                                .foregroundColor(.gray)
                        } else {
                            Text("Complete all steps to proceed")
                                .padding()
                                .foregroundColor(.gray)
                        }
                    }
                }
                .onTapGesture {
                    hideKeyboard()
                }
            }
            
            VStack {
                if showCongratsMessage {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.blue.opacity(0.7))
                            .frame(width: 300, height: 70)
                        Text("You did it! Keep Shining ✨")
                            .font(.system(size: 22, weight: .bold))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding()
                            .opacity(opacity)
                            .animation(.easeInOut(duration: 1.0), value: opacity)
                            .minimumScaleFactor(0.5)
                    }
                    .padding()
                }
                
                ConfettiCannon(counter: $confettiCounter, num: 50, radius: 500.0)
            }
        }
    }
    
    private func updateProgress() {
        viewModel.daily.completedSteps = 0
        if !viewModel.daily.firstQuestion.isEmpty {
            viewModel.daily.completedSteps = 1
            if !viewModel.daily.task.isEmpty && viewModel.daily.isFinished {
                viewModel.daily.completedSteps = 2
                if !viewModel.daily.secondQuestion.isEmpty {
                    viewModel.daily.completedSteps = 3
                }
            }
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


#Preview {
    ContentView()
}
