//
//  Daily.swift
//  Shine
//
//  Created by Jesus Sebastian Jaime Oviedo on 14/10/24.
//

import Foundation
import SwiftUI

struct Daily: Identifiable, Codable {
    var id: UUID = UUID()
    var firstQuestion: String
    var task : String
    var isFinished: Bool
    var secondQuestion: String
    var completedSteps: Int
    var streak: Int
    var progress: CGFloat
    var completed: Bool 

}


