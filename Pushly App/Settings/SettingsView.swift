//
//  SettingsView.swift
//  Pushly App
//
//  Created by Sebastián Kučera on 31.10.2023.
//

import SwiftUI
import UserNotifications
import GameKit

struct SettingsView: View {
    @EnvironmentObject var config: Config
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Starting count of exercises")) {
                    Text("\(config.startingCount)")
                }
                Section(header: Text("Increment each day")) {
                    Text("\(config.increment)")
                }
                Section(header: Text("Lenght of challange in days")) {
                    Text("\(config.lenght)")
                }
                
                Section(header: Text("Development only").foregroundColor(.red)) {}
                
                Section(header: Text("Progress days")) {
                    Text("\(config.dailyProgress)")
                }
                Section(header: Text("Last update date")) {
                    Text("\(config.lastUpdateDate)")
                }
                Section(header: Text("Ending screen")) {
                    NavigationLink("Ending screen") {
                        ChallangeEndSumaryView(config: _config)
                    }
                }
                Section(header: Text("Last updates logs")) {
                    NavigationLink("Last updates logs") {
                        UpdateLogsView()
                    }
                }
                Section(header: Text("Days descriptions")) {
                    NavigationLink("Days descriptions") {
                        DaysDescriptionsView()
                    }
                }
                Section(header: Text("User defaults")) {
                    NavigationLink("User defaults") {
                        UserDefaultsView()
                    }
                }
                
                Section(header: Text("User defaults")) {
                    Button("Is bgf needed \(String(config.isBackgroundFetchNeeded))",
                           action:  config.toggleBackgroundFetch )
                }
                
            }
            .navigationTitle(Text("Settings"))
        }
    }
}

func printUserDefaults() {
    for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
        debugPrint("\(key) = \(value) \n")
    }
}


#Preview {
    SettingsView()
}
