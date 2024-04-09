//
//  DayState.swift
//  Pushly App
//
//  Created by Sebastián Kučera on 20.11.2023.
//

import Foundation

enum DayState: String, Codable {
    case success = "Success"
    case failed = "Failed"
    case current = "Current"
    case upcoming = "Upcoming"
}
