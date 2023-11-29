//
//  Config.swift
//  Pushly App
//
//  Created by Sebastián Kučera on 30.10.2023.
//

import Foundation

class Config: ObservableObject {
    
    @Published var challangeStarted: Bool {
        didSet {
            UserDefaults.standard.set(challangeStarted, forKey: "challangeStarted")
        }
    }
    
    @Published var startingCount: String {
        didSet {
            UserDefaults.standard.set(startingCount, forKey: "startingCount")
        }
    }
    
    @Published var increment: String {
        didSet {
            UserDefaults.standard.set(increment, forKey: "increment")
        }
    }
    
    @Published var lenght: Int {
        didSet {
            UserDefaults.standard.set(lenght, forKey: "lenght")
        }
    }
    
    @Published var exercisesDone: Int {
        didSet {
            UserDefaults.standard.set(exercisesDone, forKey: "exercisesDone")
        }
    }
    
    @Published var dailyProgress: Int {
        didSet {
            UserDefaults.standard.set(dailyProgress, forKey: "dailyProgress")
        }
    }
    
    @Published var exercisesToday: Int {
        didSet {
            UserDefaults.standard.set(exercisesToday, forKey: "exercisesToday")
        }
    }
    
    @Published var lastUpdateDate: Date {
        didSet {
            UserDefaults.standard.set(lastUpdateDate, forKey: "lastUpdateDate")
        }
    }
    
        @Published var completedDays: Set<Int> {
            didSet {
                UserDefaults.standard.set(Array(completedDays), forKey: "completedDays")
            }
        }

    init(challangeStarted: Bool, startingCount: Int, increment: Int, lenght: Int, exercisesDone: Int, dailyProgress: Int, exercisesToday: Int, lastUpdateDate: Date, completedDays: Set<Int>) {
            self.challangeStarted = UserDefaults.standard.object(forKey: "challangeStarted") as? Bool ?? false
            self.startingCount = UserDefaults.standard.object(forKey: "startingCount") as? String ?? ""
            self.increment = UserDefaults.standard.object(forKey: "increment") as? String ?? ""
            self.lenght = UserDefaults.standard.object(forKey: "lenght") as? Int ?? 0
            self.exercisesDone = UserDefaults.standard.object(forKey: "exercisesDone") as? Int ?? 0
            self.dailyProgress = UserDefaults.standard.object(forKey: "dailyProgress") as? Int ?? 1
            self.exercisesToday = UserDefaults.standard.object(forKey: "exercisesToday") as? Int ?? 0
            self.lastUpdateDate = UserDefaults.standard.object(forKey: "lastUpdateDate") as? Date ?? Date.now
            let completedArray = UserDefaults.standard.array(forKey: "completedDays") as? [Int] ?? []
            self.completedDays = Set(completedArray)
        }
        
    func markDayAsComplete(day: Int) { 
        completedDays.insert(day)
        UserDefaults.standard.set(Array(completedDays), forKey: "completedDays")
    }

}

