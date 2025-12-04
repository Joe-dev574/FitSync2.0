//
//  FitSync2_0App.swift
//  FitSync2.0
//
//  Created by Joseph DeWeese on 12/3/25.
//

import SwiftUI
import SwiftData
import OSLog

@main
struct FitSync2_0App: App {
    // 1. Static container – created once, shared everywhere (including Watch)
    static let container: ModelContainer = {
        let schema = Schema([
            User.self,
            Workout.self,
            Exercise.self,
            JournalEntry.self,
            SplitTime.self,
            Category.self
        ])
        
        let config = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            cloudKitDatabase: .private("iCloud.com.tnt.FitSync")
        )
        
        do {
            return try ModelContainer(for: schema, configurations: config)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    // 2. Lazy managers – initialized only when needed
    @State private var authManager = AuthenticationManager.shared
    @State private var healthKitManager = HealthKitManager.shared
    @State private var errorManager = ErrorManager.shared
    
    @AppStorage("appearanceSetting") private var appearanceSetting: AppearanceSetting = .system
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(authManager)
                .environment(healthKitManager)
                .environment(errorManager)
                .modelContainer(Self.container)
                .preferredColorScheme(appearanceSetting.colorScheme)
                .environment(\.modelContext, Self.container.mainContext)
                .task {
                    // Only run once ever – safe, non-blocking, no race
                    await DefaultDataSeeder.ensureDefaults(in: Self.container)
                }
                .alert(item: $errorManager.currentAlert) { alert in
                    Alert(
                        title: Text(alert.title),
                        message: Text(alert.message),
                        dismissButton: alert.primaryButton
                    )
                }
        }
    }
}
