//
//  FitSync2_0App.swift
//  FitSync2.0
//
//  Created by Joseph DeWeese on 12/3/25.
//

// FitSyncApp.swift
import SwiftUI
import SwiftData

@main
struct FitSync2_0App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(AuthenticationManager.shared)
                .environment(HealthKitManager.shared)
                .environment(ErrorManager.shared)
                .modelContainer(FitSync2_0Container.container)
        }
    }
}
