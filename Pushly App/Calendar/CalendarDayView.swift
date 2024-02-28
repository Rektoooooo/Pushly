//
//  CalendarDayView.swift
//  Pushly App
//
//  Created by Sebastián Kučera on 01.11.2023.
//

import SwiftUI
import SwiftData

struct CalendarDayView: View {
    
    @State var count:Int
    @State var state: DayState
    @EnvironmentObject var config: Config

    var body: some View {
        VStack {
            List {
                Section(header: Text("Time of completion")) {
                    Text("\(config.daysDescription[count - 1].date)")
                }
                Section(header: Text("Date")) {
                    Text("\(config.daysDescription[count - 1].dateCompleated)")
                }
                Section(header: Text("Repeticions done")) {
                    Text("\(config.daysDescription[count - 1].repsCompleated)")
                }
                Section(header: Text("Day status")) {
                    Text("\(config.daysDescription[count - 1].status)")
                }
            }
            .navigationTitle("Day \(count)")
        }
    }

    private func backgroundColor(for state: DayState) -> Color {
          switch state {
              case .success:
                  return Color.green
              case .failed:
                  return Color.red
              case .current:
                  return Color.gray
              case .upcoming:
                  return Color.white
          }
      }
}

#Preview {
    CalendarDayView(count: 0, state: .upcoming)
}
