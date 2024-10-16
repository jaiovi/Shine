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
        self.daily = Daily(firstQuestion: "", task: "", isFinished: false, secondQuestion: "", completedSteps: 0, streak: 0)
        
        if let savedDaily = loadDailyFromDefaults() {
            self.daily = savedDaily
        }
        
        checkIfNewDay()
    }
    
    func checkIfNewDay() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDateString = dateFormatter.string(from: Date())
        
        if lastActiveDate != currentDateString {
            // A new day has passed, reset the daily data
            
            if self.daily.completedSteps != 3{
                self.daily.streak = 0
            }
            
                        self.daily.firstQuestion = ""
                        self.daily.task = ""
                        self.daily.isFinished = false
                        self.daily.secondQuestion = ""
                        self.daily.completedSteps = 0
            
            lastActiveDate = currentDateString
        }
    }
    
    func saveDailyToDefaults() {
        if let encoded = try? JSONEncoder().encode(daily) {
            UserDefaults.standard.set(encoded, forKey: "dailyModel")
        }
    }

    private func loadDailyFromDefaults() -> Daily? {
        if let savedDailyData = UserDefaults.standard.object(forKey: "dailyModel") as? Data {
            if let decodedDaily = try? JSONDecoder().decode(Daily.self, from: savedDailyData) {
                return decodedDaily
            }
        }
        return nil
    }
}

