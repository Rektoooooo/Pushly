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
                    Text("\(config.days[count].time)")
                }
                Section(header: Text("Date")) {
                    Text("\(config.days[count].date)")
                }
                Section(header: Text("Repeticions done")) {
                    Text("\(config.days[count].repsCompleated)")
                }
                Section(header: Text("Day status")) {
                    Text("\(config.days[count].status.rawValue)")
                }
            }
            .navigationTitle("Day \(count + 1)")
        }
        .onAppear() {
            loadData()
        }
    }
    
    func loadData() {
        let decoder = JSONDecoder()
        if let savedDaysData = UserDefaults.standard.object(forKey: "days") as? Data {
            if let loadedDays = try? decoder.decode([Day].self, from: savedDaysData) {
                config.days = loadedDays
                debugPrint("Loaded data")
            }
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
