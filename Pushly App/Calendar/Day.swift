//
//  Day.swift
//  Pushly App
//
//  Created by Sebastián Kučera on 12.12.2023.
//

import Foundation
import SwiftUI
import SwiftData

@Model
final class Day {
    @Attribute(.unique) var dayNumber: UInt
    @Attribute var status: String
    @Attribute var date: Date
    @Attribute var dateCompleated: Date
    @Attribute var repsCompleated: UInt
    
    init(dayNumber: UInt, status: String = "", date:Date = Date(), dateCompleated: Date = Date(), repsCompleated: UInt = 0) {
        self.dayNumber = dayNumber
        self.status = status
        self.date = date
        self.dateCompleated = dateCompleated
        self.repsCompleated = repsCompleated
    }
}
 

