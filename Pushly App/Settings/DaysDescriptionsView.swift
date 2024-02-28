//
//  DaysDescriptionsView.swift
//  Pushly App
//
//  Created by Sebastián Kučera on 24.02.2024.
//

import SwiftUI

struct DaysDescriptionsView: View {
    @EnvironmentObject var config: Config
    var body: some View {
        List {
            Section(header: Text("All descriptoons")) {
                ForEach(Array(config.daysDescription.enumerated()), id: \.element.dayNumber) { index, day in
                    Text("Day : \(index), Status : \(day.status), Date : \(day.dateCompleated),")
                }
            }
        }
        .navigationTitle("Days descriptions")
    }
}

#Preview {
    DaysDescriptionsView()
}

