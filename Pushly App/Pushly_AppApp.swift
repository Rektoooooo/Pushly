//
//  Pushly_AppApp.swift
//  Pushly App
//
//  Created by Sebastián Kučera on 30.10.2023.
//

import SwiftUI

@main
struct Pushly_AppApp: App {
    var body: some Scene {
        let config = Config(challangeStarted: false, startingCount: 0, increment: 0, lenght: 0, exercisesDone: 0, dailyProgress: 0, exercisesToday: 0, lastUpdateDate: Date.now, completedDays: Set<UInt>())
        WindowGroup {
            if config.challangeStarted {
                ToolBar()
                    .environmentObject(config)
            } else {
                SetUpView(challangeLenght: "")
                    .environmentObject(config)
            }
        }
    }
}
