//
//  FitSync2_0WatchAppApp.swift
//  FitSync2.0WatchApp Watch App
//
//  Created by Joseph DeWeese on 12/3/25.
//

import SwiftUI
import SwiftData



@main
struct FitSync2_0WatchAppApp: App {
    var body: some Scene {
        WindowGroup {
            WatchLandingView()
                .environment(AuthenticationManager.shared)
                .environment(HealthKitManager.shared)
                .environment(ErrorManager.shared)
                .modelContainer(FitSync2_0Container.container)
        }
    }
}

#Preview {
    WatchLandingView()
        .environment(AuthenticationManager.shared)
        .environment(HealthKitManager.shared)
        .environment(ErrorManager.shared)
        .modelContainer(FitSync2_0Container.container)
}
