//
//  CalendarView.swift
//  Pushly App
//
//  Created by Sebastián Kučera on 31.10.2023.
//

import SwiftUI
import SwiftData

struct CalendarView: View {
    
    @EnvironmentObject var config: Config
    @StateObject var calendarViewModel = CalendarViewModel()
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 8)
    
    var body: some View {
        @State var rowLenght:Int = Int(config.lenght)
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 3) {
                    ForEach(0..<rowLenght) { i in
                        let day = i + 1
                        let state = calendarViewModel.dayStates[day] ?? determineStateForDay(UInt(day))
                        NavigationLink("\(day)"){
                            CalendarDayView(count: day, state: state)
                               .modelContainer(for: Day.self)
                        }
                        .frame(width: 30, height: 30)
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                        .padding(2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(backgroundColor(for: state), lineWidth: 4)
                        )
                        .background(backgroundColor(for: state))
                        .padding(3)
                    }
                }

                .id(UUID().uuidString)
                .frame(width: UIScreen.main.bounds.width * 0.9)
                .navigationTitle(Text("Your progress"))
            }
        }
    }
    
    func determineStateForDay(_ day: UInt) -> DayState {
        if config.completedDays.contains(day) {
            return .success
        } else if !(config.completedDays.contains(day)) && !(day >= config.dailyProgress) {
            return .failed
        } else if day == config.dailyProgress {
            return .current
        } 
        return .upcoming
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
    CalendarView()
}
