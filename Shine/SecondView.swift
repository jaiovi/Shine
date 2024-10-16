//
//  SecondView.swift
//  Shine
//
//  Created by Serena Pia Capasso on 16/10/24.
//

import SwiftUI

struct SecondView: View {
    var body: some View {
            VStack {
                Text("Second View")
                    .font(.largeTitle)
                    .padding()
                
                // Add more UI elements here if needed
            }
            
            .navigationBarBackButtonHidden(true) // Hide the back button
        }
}

#Preview {
    SecondView()
}
