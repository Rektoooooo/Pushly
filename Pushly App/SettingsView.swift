//
//  SettingsView.swift
//  Pushly App
//
//  Created by Sebastián Kučera on 31.10.2023.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var config: Config
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Starting count of exercises")) {
                    Text(config.startingCount)
                }
                Section(header: Text("Increment each day")) {
                    Text(config.increment)
                }
                Section(header: Text("Lenght of challange in days")) {
                    Text("\(config.lenght)")
                }
                
                Section(header: Text("Development only").foregroundColor(.red)) {}
                
                Section(header: Text("Progress days")) {
                    Text("\(config.dailyProgress)")
                }
                Section(header: Text("Compleated days")) {
                    Text("\(config.completedDays.sorted().map { String($0) }.joined(separator: ", "))")
                }
            }
            .navigationTitle(Text("Settings"))
        }
    }
}

#Preview {
    SettingsView()
}
