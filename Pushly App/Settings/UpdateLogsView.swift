//
//  updateLogsView.swift
//  Pushly App
//
//  Created by Sebastián Kučera on 29.01.2024.
//

import SwiftUI

struct UpdateLogsView: View {
    @EnvironmentObject var config: Config
    @State private var showAlert = false
    var body: some View {
        List {
            Section(header: Text("All logs")) {
                ForEach(Array(config.updateLogs.enumerated()), id: \.element) { index, date in
                    Text("\(index) : \(date)")
                }
                .onDelete(perform: delete)
            }
            Section(header: Text("Delete all logs")) {
                Button("Delete all logs") {
                    showAlert = true
                }
                .alert("Confirm Action", isPresented: $showAlert) {
                           Button("Cancel", role: .cancel) { }
                           Button("OK") {
                               config.updateLogs.removeAll()
                           }
                           .foregroundColor(.red)
                       } message: {
                           Text("Are you sure you want to proceed?")
                       }
                .foregroundColor(.red)
            }
        }
        .navigationTitle("Logs")
    }
    
    func delete(at offsets: IndexSet) {
        config.updateLogs.remove(atOffsets: offsets)
    }
    
}



#Preview {
    UpdateLogsView()
}
