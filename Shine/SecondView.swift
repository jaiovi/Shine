//
//  SecondView.swift
//  Shine
//
//  Created by Serena Pia Capasso on 16/10/24.
//

import SwiftUI

struct SecondView: View {
    
    @StateObject private var viewModel = DailyViewModel()
    let totalSteps: Int = 3
    var body: some View {
        HStack {
          
            
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
            
            
        }
}

#Preview {
    SecondView()
}
