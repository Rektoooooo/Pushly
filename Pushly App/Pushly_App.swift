//
//  Pushly_AppApp.swift
//  Pushly App
//
//  Created by Sebastián Kučera on 30.10.2023.
//

import SwiftUI
import BackgroundTasks

@main
struct Pushly_App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) private var phase
    
    init() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { result, error in
            if let error = error {
                print(error)
            }
        }
    }
    
    var body: some Scene {
        let config = Config(challangeStarted: false, startingCount: 0, increment: 0, lenght: 0, exercisesDone: 0, dailyProgress: 0, exercisesToday: 0, lastUpdateDate: Date(), completedDays: Set<UInt>(),updateLogs: Array<Date>(),
                            days: [Day(dayNumber: 1, status: "Upcoming", date: "Not compleated yet", dateCompleated: "", repsCompleated: 0)], sendNotification: true)
        WindowGroup {
            if config.challangeStarted {
                ToolBar()
                    .environmentObject(config)
                
            } else {
                SetUpView()
                    .environmentObject(config)
            }
        }
        .onChange(of: phase) { oldValue, newValue in
            switch newValue {
            case .background : Task {
                await scheduleBackgroundNotification()
            }
            default : break
            }
        }
        .backgroundTask(.appRefresh("notification")) {
            await scheduleBackgroundNotification()
            if await needNotification() {
                await sendReminderNotification()
            }
        }
    }
    
    func needNotification() -> Bool {
        let exercisesDone = UserDefaults.standard.integer(forKey: "completedPushups")
        let exercisesToday = UserDefaults.standard.integer(forKey: "dailyGoal")
        if exercisesDone <= exercisesToday {
            return true
        } else {
            return false
        }
    }
    
    
    func scheduleBackgroundNotification() async {
        var notificationTime = DateComponents()
        notificationTime.hour = 20
        notificationTime.minute = Int.random(in: 0...59)
        
        let calendar = Calendar.current
        
        if let date = calendar.date(from: notificationTime) {
            let request = BGAppRefreshTaskRequest(identifier: "notification")
            request.earliestBeginDate = date
            do {
                try BGTaskScheduler.shared.submit(request)
                print("Schedul background task")
            } catch {
                print("Could not schedule app refresh: \(error)")
            }
        }
    }
    
    func sendReminderNotification() async {
        
        let notificationTitles: [String] = [
            "Daily Goal Awaiting Completion!",
            "Your Push-Up Target Isn't Met Yet!",
            "Still Time to Achieve Today's Goal!",
            "Push-Up Goal: Pending Achievement!",
            "Finish Line for Today's Goal Ahead!",
            "Your Daily Challenge Awaits!",
            "Goal Alert: Push-Ups Pending!",
            "Today's Fitness Milestone Unreached!",
            "Complete Your Push-Up Quota Today!",
            "End-of-Day Goal Check: Incomplete!"
        ]
        
        let notificationDescriptions: [String] = [
            "Your muscles are waiting for their daily challenge. Let's hit those push-ups now!",
            "It's time to empower your day with some push-ups. Rise and grind!",
            "Haven't felt the burn today? There's still time for your push-up session!",
            "Remember, every push-up makes you stronger. Ready to add a few more to your tally?",
            "Strength isn't built in a day, but daily push-ups are a step in the right direction. Go for it!",
            "Let's not skip today's push-up routine. Your future self will thank you!",
            "Feeling lazy? Just a few push-ups can turn your day around. You've got this!",
            "Consistency is key, and your push-up streak is waiting to be extended. Push through!",
            "A few push-ups away from greatness. Dive in and elevate your fitness level!",
            "End your day on a high note with a quick push-up session. Every rep counts!"
        ]
        
        let content = UNMutableNotificationContent()
        content.title = "\(notificationTitles.randomElement() ?? "Compleat your daily goal")"
        content.body = "\(notificationDescriptions.randomElement() ?? "Your daily goal hasen't been compleated yet, so get up and do it")"
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        do {
            try await UNUserNotificationCenter.current().add(request)
        } catch {
            print("Could not send an notification : \(error)")
        }
        print("Notification was sended")
    }
}
