//
//  Day.swift
//  Pushly App
//
//  Created by Sebastián Kučera on 12.12.2023.
//

import Foundation
import SwiftUI
import SwiftData

class Day: Codable, CustomStringConvertible {
    
    var dayNumber: UInt
    var status: DayState
    var time: String
    var date: String
    var repsCompleated: UInt
    var finished: Bool
    
    init(dayNumber: UInt, status: DayState = .upcoming, time: String = "", date: String = "", repsCompleated: UInt = 0, finished: Bool = false) {
        self.dayNumber = dayNumber
        self.status = status
        self.time = time
        self.date = date
        self.repsCompleated = repsCompleated
        self.finished = finished
    }
    
    var description: String {
        return "\(self.status) \n\(self.time) \n\(self.finished)"
    }
}
 

