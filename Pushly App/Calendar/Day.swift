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
    var status: String
    var date: String
    var dateCompleated: String
    var repsCompleated: UInt
    var finished: Bool
    
    init(dayNumber: UInt, status: String = "", date:String = "", dateCompleated: String = "", repsCompleated: UInt = 0, finished: Bool = false) {
        self.dayNumber = dayNumber
        self.status = status
        self.date = date
        self.dateCompleated = dateCompleated
        self.repsCompleated = repsCompleated
        self.finished = finished
    }
    
    var description: String {
        return "\(self.status) \n\(self.date) \n\(self.finished)"
    }
}
 

