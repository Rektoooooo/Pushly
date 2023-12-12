//
//  StartedView.swift
//  Pushly App
//
//  Created by Sebastián Kučera on 30.10.2023.
//

import SwiftUI

struct StartedView: View {
    
    @EnvironmentObject var config: Config
    @State private var timeRemaining: TimeInterval = 0
    @State var midnight:Date = Date()
    @State var isValueChanged: Bool = false

    var body: some View {
        VStack {
            Text("Challange started")
                .font(.system(size: 40))
                .fontWeight(.heavy)
            Spacer()
            Text("Push'ups today")
            Text("\(config.exercisesToday)")
                .font(.system(size: 40))
                .fontWeight(.heavy)
            Text("Time remaining")
            Text(timeString(time: timeRemaining))
                .font(.system(size: 40))
                .fontWeight(.heavy)
            Text("Push'ups done")
            HStack {
                Button(action: {
                    if config.exercisesDone > 0 {
                        config.exercisesDone -= 1
                    }
                }, label: {
                    Text("-")
                        .font(.system(size: 40))
                })
                Text("\(config.exercisesDone)")
                    .font(.system(size: 40))
                    .fontWeight(.heavy)
                    .onChange(of: config.exercisesDone) { oldValue, newValue in
                        isValueChanged = true
                    }

                Button(action: {
                    if config.exercisesDone >= 0  {
                        config.exercisesDone += 1
                    }
                }, label: {
                    Text("+")
                        .font(.system(size: 40))
                })
            }
            VStack {
                Slider(
                    value: Binding(
                        get: { Double(config.exercisesDone) },
                        set: { config.exercisesDone = Int($0) }
                    ),
                    in: 0...Double(config.exercisesToday)
                )
            }
            .frame(width: UIScreen.main.bounds.width * 0.8)
            Button(action: {
                isValueChanged = false
                refreshApp()
            }, label: {
                Text("Save")
                    .padding()
                    .padding(.leading,50)
                    .padding(.trailing,50)
                    .background(isValueChanged ? Color .blue : Color .gray) 
                    .foregroundColor(.white)
                    .cornerRadius(40)
                    .shadow(radius: 20)
                    .bold()
            })
            Spacer()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            refreshApp()
        }
        .onFirstAppear {
            setTimer()
            refreshApp()
        }
    }
    
    private func refreshApp() {
        updateDailyChallengeIfNeeded(config: config)
        refreshTimer()
        updateExercisesToday()
        checkIfGoalCompleated()
        print("App refreshed \(Date())")
        // printUserDefaults()
    }
    
    private func setTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.timeRemaining -= 1
        }
    }
    
    func printUserDefaults() {
        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
            print("\(key) = \(value) \n")
        }
    }
    
    private func refreshTimer() {
        let now = Date()
        let calendar = Calendar.current
        midnight = calendar.startOfDay(for: now).addingTimeInterval(24 * 60 * 60)
        self.timeRemaining = midnight.timeIntervalSince(now) + 1
    }

    private func timeString(time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) / 60) % 60
        let seconds = Int(time) % 60
        
        let calendar = Calendar.current
        let now = Date()
        
        let startOfDay = calendar.startOfDay(for: now)
        _ = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? now
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func updateDailyChallengeIfNeeded(config: Config) {
        let now = Date()
        let calendar = Calendar.current
        if !calendar.isDate(config.lastUpdateDate, inSameDayAs: now) {
            if let yesterday = calendar.date(byAdding: .day, value: -1, to: now),
               calendar.isDate(config.lastUpdateDate, inSameDayAs: yesterday) {
                updateDailyChallenge()
            }
            config.lastUpdateDate = now
        }
    }

    private func updateDailyChallenge() {
        updateExercisesToday()
        config.dailyProgress += numberOfNightsBetween(startDate: config.lastUpdateDate)
        config.exercisesDone = 0
        print("Updated challange")
    }
    
    private func numberOfNightsBetween(startDate: Date) -> Int {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year,.month,.day,.hour,.minute,.second], from: startDate)
        components.hour = 0
        components.minute = 0
        components.second = 0
        guard let midnight = calendar.date(from: components) else { return 0 }
        return calendar.dateComponents([.day], from: midnight, to: Date.now).day ?? 0
    }
    
    private func updateExercisesToday() {
        let progress:Int = config.dailyProgress - 1
        let inc:Int = Int(config.increment) ?? 0
        let start:Int = Int(config.startingCount) ?? 0
        config.exercisesToday = start + (inc * progress)
    }
    
    private func checkIfGoalCompleated() {
        if config.exercisesDone >= config.exercisesToday {
            config.markDayAsComplete(day: config.dailyProgress)
        } else {
            config.completedDays.remove(config.dailyProgress)
        }
    }
    
}

#Preview {
    StartedView()
}
