//
//  ContentView.swift
//  Pushly App
//
//  Created by Sebastián Kučera on 30.10.2023.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var config: Config
    @State var isPresented: Bool = false
    @State var challangeLenght: String = ""
    var body: some View {
        VStack {
            Text("Challange setup")
                .multilineTextAlignment(.center)
                .font(.system(size: 30))
            List {
                Section(header: Text("Starting count of exercises")) {
                    TextField(config.startingCount, text: $config.startingCount)
                        .keyboardType(.numberPad)
                        .background(Color.clear)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                Section(header: Text("Increment each day")) {
                    TextField(config.increment, text: $config.increment)
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
            .frame(height: UIScreen.main.bounds.height * 0.5)
            Button("Start Challange") {
                startChallange()
            }
            Spacer()
        }
        .fullScreenCover(isPresented: $isPresented, content: {
            MainView()
        })
    }
    
    func startChallange() {
        config.challangeStarted = true
        isPresented.toggle()
        config.lenght = Int(challangeLenght) ?? 0
        config.exercisesToday = Int(config.startingCount) ?? 0 + (Int(config.increment) ?? 0 * config.dailyProgress)
        print("Variables pushed to config")
    }
    
}

#Preview {
    ContentView(challangeLenght: "")
}
