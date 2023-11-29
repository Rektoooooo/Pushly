//
//  CalendarViewModel.swift
//  Pushly App
//
//  Created by Sebastián Kučera on 23.11.2023.
//

import Foundation

class CalendarViewModel: ObservableObject {
    @Published var dayStates: [Int: DayState] = [:]
}
