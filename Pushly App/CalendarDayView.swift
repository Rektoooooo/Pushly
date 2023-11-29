//
//  CalendarDayView.swift
//  Pushly App
//
//  Created by Sebastián Kučera on 01.11.2023.
//

import SwiftUI

struct CalendarDayView: View {
    @State var count:Int
    @State var state: DayState
    var body: some View {
        Text("\(count)")
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
