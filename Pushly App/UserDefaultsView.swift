//
//  UserDefaultsView.swift
//  Pushly App
//
//  Created by Sebastián Kučera on 10.12.2023.
//

import SwiftUI

struct UserDefaultsView: View {
    @State var userDefaults: [UserData] = []
    var body: some View {
            List {
                ForEach(userDefaults) { data in
                    Text("\(data.key) : \(data.value)")
                }
            }
            .navigationTitle("User defaults")
            .onAppear() {
                userDefaults = printUserDefaults()
            }   
    }
    
    struct UserData: Identifiable {
        var id = UUID()
        let key: String
        let value: String
    }
    
    func printUserDefaults() -> [UserData] {
        let keys = ["startingCount","increment","lastUpdateDate","lenght","dailyProgress","exercisesDone","completedDays","exercisesToday"]
        let userDefaults = UserDefaults.standard.dictionaryRepresentation()
        var result:[UserData] = []
        keys.forEach { key in
            if let value = userDefaults[key] as? CustomStringConvertible {
                let data = UserData(key:key, value: value.description)
                result.append(data)
            }
        }
        return result
    }
}
