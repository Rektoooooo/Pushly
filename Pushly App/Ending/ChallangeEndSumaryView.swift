//
//  ChallangeEndSumaryView.swift
//  Pushly App
//
//  Created by Sebastián Kučera on 06.03.2024.
//

import SwiftUI

struct ChallangeEndSumaryView: View {
    @EnvironmentObject var config: Config
    var body: some View {
        VStack {
            Text("Challange compleated")
            Text("\(config.completedDays.count) / \(Int(config.lenght)) Days compleated")
            Text("\((Double(Double(config.completedDays.count) / Double(config.lenght)) * 100).rounded())% Success rate")
            Spacer()
        }
        .onAppear() {
            debugPrint("\(config.completedDays.count) / \(Int(config.lenght))")
            debugPrint((Float(Double(config.completedDays.count) / Double(config.lenght)) * 100).rounded())
        }
    }
}

#Preview {
    ChallangeEndSumaryView()
}
