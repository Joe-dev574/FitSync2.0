//
//  FitSyncContainer.swift
//  FitSync2.0
//
//  Created by Joseph DeWeese on 12/4/25.
//

import SwiftData

public enum FitSync2_0Container {
    public static let container: ModelContainer = {
        let schema = Schema([
            User.self,
            Category.self,
            Workout.self,
            Exercise.self,
            JournalEntry.self,
            SplitTime.self
        ])
        
        let config = ModelConfiguration(
            cloudKitDatabase: .private("iCloud.com.tnt.FitSync")
        )
        
        return try! ModelContainer(for: schema, configurations: config)
    }()
}
