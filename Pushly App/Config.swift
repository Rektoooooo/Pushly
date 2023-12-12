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
    
    @Published var lenght: UInt {
        didSet {
            UserDefaults.standard.set(lenght, forKey: "lenght")
        }
    }
    
    @Published var exercisesDone: UInt {
        didSet {
            UserDefaults.standard.set(exercisesDone, forKey: "exercisesDone")
        }
    }
    
    @Published var dailyProgress: UInt {
        didSet {
            UserDefaults.standard.set(dailyProgress, forKey: "dailyProgress")
        }
    }
    
    @Published var exercisesToday: UInt {
        didSet {
            UserDefaults.standard.set(exercisesToday, forKey: "exercisesToday")
        }
    }
    
    @Published var lastUpdateDate: Date {
        didSet {
            UserDefaults.standard.set(lastUpdateDate, forKey: "lastUpdateDate")
        }
    }
    
        @Published var completedDays: Set<UInt> {
            didSet {
                UserDefaults.standard.set(Array(completedDays), forKey: "completedDays")
            }
        }

    init(challangeStarted: Bool, startingCount: UInt, increment: UInt, lenght: UInt, exercisesDone: UInt, dailyProgress: UInt, exercisesToday: UInt, lastUpdateDate: Date, completedDays: Set<UInt>) {
            self.challangeStarted = UserDefaults.standard.object(forKey: "challangeStarted") as? Bool ?? false
            self.startingCount = UserDefaults.standard.object(forKey: "startingCount") as? String ?? ""
            self.increment = UserDefaults.standard.object(forKey: "increment") as? String ?? ""
            self.lenght = UserDefaults.standard.object(forKey: "lenght") as? UInt ?? 0
            self.exercisesDone = UserDefaults.standard.object(forKey: "exercisesDone") as? UInt ?? 0
            self.dailyProgress = UserDefaults.standard.object(forKey: "dailyProgress") as? UInt ?? 1
            self.exercisesToday = UserDefaults.standard.object(forKey: "exercisesToday") as? UInt ?? 0
            self.lastUpdateDate = UserDefaults.standard.object(forKey: "lastUpdateDate") as? Date ?? Date.now
            let completedArray = UserDefaults.standard.array(forKey: "completedDays") as? [UInt] ?? []
            self.completedDays = Set(completedArray)
        }
        
    func markDayAsComplete(day: UInt) {
        completedDays.insert(day)
        UserDefaults.standard.set(Array(completedDays), forKey: "completedDays")
    }

}

