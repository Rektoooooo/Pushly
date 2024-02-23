//
//  Day.swift
//  Pushly App
//
//  Created by Sebastián Kučera on 12.12.2023.
//

import Foundation
import SwiftUI
import SwiftData

struct Day: Codable {
    var dayNumber: UInt
    var status: String
    var date: String
    var dateCompleated: String
    var repsCompleated: UInt
    
    init(dayNumber: UInt, status: String = "", date:String = "", dateCompleated: String = "", repsCompleated: UInt = 0) {
        self.dayNumber = dayNumber
        self.status = status
        self.date = date
        self.dateCompleated = dateCompleated
        self.repsCompleated = repsCompleated
    }
}
 

