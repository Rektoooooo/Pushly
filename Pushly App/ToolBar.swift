//
//  MainView.swift
//  Pushly App
//
//  Created by Sebastián Kučera on 31.10.2023.
//

import SwiftUI

struct ToolBar: View {
    @EnvironmentObject var config: Config
       var body: some View {
           TabView {
               Group {
                   StartedView()
                     .tabItem {
                       Label("Landing page", systemImage: "house")
                     }
                     .tag(1)

                  CalendarView()
                     .tabItem {
                       Label("Progress", systemImage: "calendar")
                     }
                     .tag(2)
                   
                   SettingsView()
                     .tabItem {
                       Label("Settings", systemImage: "gear")
                     }
                     .navigationTitle("Settings")
                     .tag(3)
                   
               }
               .toolbar(.visible, for: .tabBar)
               .toolbarBackground(.black, for: .tabBar)

           }
           .environmentObject(config)
       }
}

#Preview {
    ToolBar()
}
