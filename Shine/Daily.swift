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
    var Question1: String
    var Task : String
    var FinishedTask: Bool
    var Question2: String
}
