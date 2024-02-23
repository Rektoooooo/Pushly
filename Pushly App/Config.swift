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
    
    @Published var startingCount: UInt {
        didSet {
            UserDefaults.standard.set(startingCount, forKey: "startingCount")
        }
    }
    
    @Published var increment: UInt {
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
    
    @Published var sendNotification: Bool {
        didSet {
            UserDefaults.standard.set(sendNotification, forKey: "sendNotification")
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
    
    @Published var updateLogs: Array<Date> {
            didSet {
                UserDefaults.standard.set(Array(updateLogs), forKey: "updateLogs")
        }
    }
    
    @Published var daysDescription: Array<Day> {
            didSet {
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(daysDescription) {
                    UserDefaults.standard.set(encoded, forKey: "daysDescription")
                }
        }
    }

    init(challangeStarted: Bool, startingCount: UInt, increment: UInt, lenght: UInt, exercisesDone: UInt, dailyProgress: UInt, exercisesToday: UInt, lastUpdateDate: Date, completedDays: Set<UInt>,updateLogs: Array<Date>, daysDescription: [Day], sendNotification: Bool) {
            self.challangeStarted = UserDefaults.standard.object(forKey: "challangeStarted") as? Bool ?? false
            self.startingCount = UserDefaults.standard.object(forKey: "startingCount") as? UInt ?? 0
            self.increment = UserDefaults.standard.object(forKey: "increment") as? UInt ?? 0
            self.lenght = UserDefaults.standard.object(forKey: "lenght") as? UInt ?? 0
            self.exercisesDone = UserDefaults.standard.object(forKey: "exercisesDone") as? UInt ?? 0
            self.dailyProgress = UserDefaults.standard.object(forKey: "dailyProgress") as? UInt ?? 1
            self.exercisesToday = UserDefaults.standard.object(forKey: "exercisesToday") as? UInt ?? 0
            self.sendNotification = UserDefaults.standard.object(forKey: "sendNotification") as? Bool ?? true
            self.lastUpdateDate = UserDefaults.standard.object(forKey: "lastUpdateDate") as? Date ?? Date.now
            self.updateLogs = UserDefaults.standard.object(forKey: "updateLogs") as? [Date] ?? [Date.now]
            self.daysDescription = UserDefaults.standard.object(forKey: "daysDescription") as? [Day] ?? [Day(dayNumber:1, status: "Upcoming",date: "Not compleated yet", dateCompleated: "Not compleated yet", repsCompleated: 0)]
            let completedArray = UserDefaults.standard.array(forKey: "completedDays") as? [UInt] ?? []
            self.completedDays = Set(completedArray)
        }
        
    func markDayAsComplete(day: UInt) {
        completedDays.insert(day)
        UserDefaults.standard.set(Array(completedDays), forKey: "completedDays")
    }

}

