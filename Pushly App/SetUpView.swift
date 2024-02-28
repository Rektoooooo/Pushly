//
//  ContentView.swift
//  Pushly App
//
//  Created by Sebastián Kučera on 30.10.2023.
//

import SwiftUI

struct SetUpView: View {
    
    @EnvironmentObject var config: Config
    @State var isPresented: Bool = false
    @State var challangeLenght: String = ""
    @State var startingCount: String = ""
    @State var increment: String = ""
    
    var body: some View {
        VStack {
            Text("Challange setup")
                .multilineTextAlignment(.center)
                .font(.system(size: 30))
            List {
                Section(header: Text("Starting count of exercises")) {
                    TextField("\(config.startingCount)", text: $startingCount)
                        .keyboardType(.numberPad)
                        .background(Color.clear)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                Section(header: Text("Increment each day")) {
                    TextField("\(config.increment)", text: $increment)
                        .keyboardType(.numberPad)
                        .background(Color.clear)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                }
                Section(header: Text("Lenght of challange in days")) {
                    TextField("\(config.lenght)", text: $challangeLenght)
                        .keyboardType(.numberPad)
                        .background(Color.clear)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
            .onAppear() {
                startingCount = "20"
                increment = "2"
                challangeLenght = "100"
            }
            .frame(height: UIScreen.main.bounds.height * 0.5)
            Button("Start Challange") {
                startChallange()
            }
            Spacer()
        }
        .fullScreenCover(isPresented: $isPresented, content: {
            ToolBar()
        })
    }
    
    func startChallange() {
        config.challangeStarted = true
        isPresented.toggle()
        config.lenght = UInt(challangeLenght) ?? 0
        config.startingCount = UInt(startingCount) ?? 0
        config.increment = UInt(increment) ?? 0
        config.exercisesToday = config.startingCount + (config.increment * config.dailyProgress)
        fillDaysCollection()
        print("Variables pushed to config")
    }
    
    func fillDaysCollection() {
        var tempDays: [Day] = []

        for i in 1...100 {
            let newDay = Day(dayNumber: UInt(i),
                             status: "Upcoming",
                             date: "Not completed yet",
                             dateCompleated: todaysDateStringDay(days: Double(i)),
                             repsCompleated: 0)
            tempDays.append(newDay)
        }

        config.daysDescription = tempDays
        saveDaysDescription()
    }
    
    private func saveDaysDescription() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(config.daysDescription) {
            UserDefaults.standard.set(encoded, forKey: "daysDescription")
        }
        print("Saved collection")
    }
    
    func todaysDateStringDay(days: Double) -> String {
        let day:Double = 86400
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: Date.now + (day * (days - 1)))
    }
    
}

#Preview {
    SetUpView(challangeLenght: "")
}
