//
//  StartedView.swift
//  Pushly App
//
//  Created by Sebastián Kučera on 30.10.2023.
//

import SwiftUI
import SwiftData
import NotificationCenter

struct StartedView: View {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
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
                        set: { config.exercisesDone = UInt($0) }
                    ),
                    in: 0...Double(config.exercisesToday)
                )
            }
            .frame(width: UIScreen.main.bounds.width * 0.8)
            Button(action: {
                isValueChanged = false
                refreshApp()
                editDay()
                checkIfGoalCompleated()
                editRepsDone()
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
    
    func refreshApp() {
        loadData()
        updateExercisesToday()
        updateDailyChallengeIfNeeded()
        refreshTimer()
        debugPrint("App refreshed \(Date())")
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
    
    private func setTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.timeRemaining -= 1
        }
    }
    
    func printUserDefaults() {
        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
            debugPrint("\(key) = \(value) \n")
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
    
    private func updateDailyChallengeIfNeeded() {
        let calendar = Calendar.current
        if !calendar.isDateInToday(config.lastUpdateDate) {
            updateDailyChallenge()
        }
    }
    
    private func updateDailyChallenge() {
        config.dailyProgress += numberOfNightsBetween(startDate: config.lastUpdateDate)
        updateExercisesToday()
        config.exercisesDone = 0
        fillMissingDays()
        currentDay()
        config.lastUpdateDate = Date()
        config.updateLogs.append(config.lastUpdateDate)
        debugPrint("Updated challange")
    }
    
    private func numberOfNightsBetween(startDate: Date) -> UInt {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year,.month,.day,.hour,.minute,.second], from: startDate)
        components.hour = 0
        components.minute = 0
        components.second = 0
        guard let midnight = calendar.date(from: components) else { return 0 }
        return UInt(calendar.dateComponents([.day], from: midnight, to: Date.now).day ?? 0)
    }
    
    private func updateExercisesToday() {
        config.exercisesToday = config.startingCount + (config.increment * (config.dailyProgress))
    }
    
    private func checkIfGoalCompleated() {
        if config.exercisesDone >= config.exercisesToday {
            config.markDayAsComplete(day: config.dailyProgress)
        } else {
            config.completedDays.remove(config.dailyProgress)
        }
    }
    
    private func fillMissingDays() {
        for i in 0..<config.dailyProgress {
            loadData()
            let day = config.days[Int(i)]
            if day.finished == false {
                day.status = .failed
                day.time = "Failed"
                saveDays()
                debugPrint("Edited failed day at : \(i) ")
            }
        }
    }
    
    private func editDay() {
        if config.exercisesDone >= config.exercisesToday {
            let day = config.days[Int(config.dailyProgress)]
            day.status = .success
            day.time = currentTimeString()
            day.repsCompleated = config.exercisesDone
            day.finished = true
            saveDays()
            debugPrint(day)
            debugPrint("Edited successful day at index: \(config.dailyProgress)")
        }
    }
    
    private func currentDay() {
            let day = config.days[Int(config.dailyProgress)]
            day.status = .current
            saveDays()
            debugPrint("Edited current day at index: \(config.dailyProgress)")
    }
    
    private func editRepsDone() {
        let day = config.days[Int(config.dailyProgress)]
        day.repsCompleated = config.exercisesDone
        saveDays()
    }
    
    private func saveDays() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(config.days) {
            UserDefaults.standard.set(encoded, forKey: "days")
            debugPrint("Saved collection")
        }
    }
    
    private func currentTimeString() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .none
        return formatter.string(from: Date.now)
    }
    
    private func todaysDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: Date())
    }
    
    private func todaysDateStringDay(days: Double) -> String {
        let day:Double = 86400
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: Date.now + (day * (days - 1)))
    }
}

#Preview {
    StartedView()
}
