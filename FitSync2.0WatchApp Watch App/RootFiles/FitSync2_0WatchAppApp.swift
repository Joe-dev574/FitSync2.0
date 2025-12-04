//
//  FitSync2_0WatchAppApp.swift
//  FitSync2.0WatchApp Watch App
//
//  Created by Joseph DeWeese on 12/3/25.
//

import SwiftUI
import FitSyncShared  // Now resolves after fixes
import SwiftData

@main
struct FitSincWatchAppApp: App {
    var body: some Scene {
        WindowGroup {
            WatchLandingView()
                .environment(AuthenticationManager.shared)
                .environment(HealthKitManager.shared)
                .environment(ErrorManager.shared)
                .modelContainer(FitSyncContainer.container)
        }
    }
}

#Preview {
    WatchLandingView()
        .environment(AuthenticationManager.shared)
        .environment(HealthKitManager.shared)
        .environment(ErrorManager.shared)
        .modelContainer(FitSyncContainer.container)
}
