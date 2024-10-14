//
//  DailyViewModel.swift
//  Shine
//
//  Created by Jesus Sebastian Jaime Oviedo on 14/10/24.
//

import SwiftUI

class DailyViewModel: ObservableObject {
    @Published var daily: Daily
    @AppStorage("lastActiveDate") private var lastActiveDate: String = ""
    
    init() {
        // Initialize daily to an empty/default value first
        self.daily = Daily(Question1: "", Task: "", FinishedTask: false, Question2: "")
        
        // Now it's safe to use 'self' to call methods
        if let savedDaily = loadDailyFromDefaults() {
            self.daily = savedDaily
        }
        
        // Check if a new day has passed and reset the data if necessary
        checkIfNewDay()
    }
    
    // Check if a new day has passed and reset daily data if needed
    func checkIfNewDay() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDateString = dateFormatter.string(from: Date())
        
        if lastActiveDate != currentDateString {
            // A new day has passed, reset the daily data
            self.daily = Daily(Question1: "", Task: "", FinishedTask: false, Question2: "")
            lastActiveDate = currentDateString
        }
    }
    
    // Save the daily model to UserDefaults
    func saveDailyToDefaults() {
        if let encoded = try? JSONEncoder().encode(daily) {
            UserDefaults.standard.set(encoded, forKey: "dailyModel")
        }
    }

    // Load the daily model from UserDefaults
    private func loadDailyFromDefaults() -> Daily? {
        if let savedDailyData = UserDefaults.standard.object(forKey: "dailyModel") as? Data {
            if let decodedDaily = try? JSONDecoder().decode(Daily.self, from: savedDailyData) {
                return decodedDaily
            }
        }
        return nil
    }
}
