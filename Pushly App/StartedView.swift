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
    
//    @Query(sort:\Day.dayNumber, order: .forward) var days: [Day]
//    @Environment(\.modelContext) var modelContext

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
                addDay(dayNumber: UInt(config.dailyProgress))
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
        loadData()
        updateDailyChallengeIfNeeded()
        refreshTimer()
        updateExercisesToday()
        checkIfGoalCompleated()
        print("App refreshed \(Date())")
    }
    
    func loadData() {
        let decoder = JSONDecoder()
        if let savedDaysData = UserDefaults.standard.object(forKey: "daysDescription") as? Data {
            if let loadedDays = try? decoder.decode([Day].self, from: savedDaysData) {
                config.daysDescription = loadedDays
                print("Loaded data")
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
    
    func updateDailyChallengeIfNeeded() {
        let calendar = Calendar.current
        if !calendar.isDateInToday(config.lastUpdateDate) {
                updateDailyChallenge()
            }
    }

    private func updateDailyChallenge() {
        updateExercisesToday()
        config.dailyProgress += numberOfNightsBetween(startDate: config.lastUpdateDate)
        config.exercisesDone = 0
        config.lastUpdateDate = Date()
        config.updateLogs.append(Date.now)
        fillMissingDays()
        print("Updated challange")
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
        config.exercisesToday = config.startingCount + (config.increment * (config.dailyProgress - 1))
    }
    
    private func checkIfGoalCompleated() {
        if config.exercisesDone >= config.exercisesToday {
            config.markDayAsComplete(day: config.dailyProgress)
        } else {
            config.completedDays.remove(config.dailyProgress)
        }
    }
    
    private func fillMissingDays() {
        for i in 1..<config.dailyProgress + 1 {
            if !config.completedDays.contains(i) && i <= config.dailyProgress {
                    var day = config.daysDescription[Array<Day>.Index(i)]
                    day.status = "Failed"
                    day.date = "Failed"
                    day.repsCompleated = 0
                    print("Edited failed day at : \(i) ")
            }
        }
    }
    
    func addDay(dayNumber: UInt) {
        if config.exercisesDone >= config.exercisesToday {
            if let existingIndex = config.daysDescription.firstIndex(where: { $0.dayNumber == dayNumber }) {
                config.daysDescription[existingIndex] = Day(dayNumber: dayNumber, status: "Success", date: currentTimeString(), dateCompleated: todaysDateString(), repsCompleated: config.exercisesDone)
            } else {
                let newDay = Day(dayNumber: dayNumber, status: "Success", date: currentTimeString(), dateCompleated: todaysDateString(), repsCompleated: config.exercisesDone)
                config.daysDescription.append(newDay)
            }
            print("Processed day at index: \(dayNumber)")
        }
    }


    
    func currentTimeString() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .none
        return formatter.string(from: Date.now)
    }
    
    func todaysDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: Date())
    }
    
    func todaysDateStringDay(days: Double) -> String {
        let day:Double = 86400
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: Date.now + (day * (days - 1)))
    }
}

#Preview {
    StartedView()
}
