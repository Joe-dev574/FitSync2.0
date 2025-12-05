//
//  DefaultDataSeeder.swift
//  FitSync2.0
//
//  Created by Joseph DeWeese on 12/4/25.
//

import SwiftData
import OSLog


actor DefaultDataSeeder {
    static func ensureDefaults(in container: ModelContainer) async {
        let context = ModelContext(container)
        let logger = Logger(subsystem: "com.tnt.FitSync2_0", category: "Seeder")
        
        // Only seed if NO User exists (first launch ever)
        let userCount: Int = (try? context.fetchCount(FetchDescriptor<User>())) ?? 0
        guard userCount == 0 else { return }
        
        let categoryCount: Int = (try? context.fetchCount(FetchDescriptor<Category>())) ?? 0
        guard categoryCount == 0 else { return }
        
        logger.info("First launch detected – seeding default categories")
        
        let defaults: [Category] = [
            Category(categoryName: "HIIT", symbol: "dumbbell.fill", categoryColor: .HIIT),
            Category(categoryName: "Strength", symbol: "figure.strengthtraining.traditional", categoryColor: .STRENGTH),
            Category(categoryName: "Run", symbol: "figure.run", categoryColor: .RUN),
            Category(categoryName: "Yoga", symbol: "figure.yoga", categoryColor: .YOGA),
            Category(categoryName: "Cycling", symbol: "figure.outdoor.cycle", categoryColor: .CYCLING),
            Category(categoryName: "Swimming", symbol: "figure.pool.swim", categoryColor: .SWIMMING),
            Category(categoryName: "Wrestling", symbol: "figure.wrestling", categoryColor: .GRAPPLING),
            Category(categoryName: "Recovery", symbol: "figure.mind.and.body", categoryColor: .RECOVERY),
            Category(categoryName: "Walk", symbol: "figure.walk.motion", categoryColor: .WALK),
            Category(categoryName: "Stretch", symbol: "figure.cooldown", categoryColor: .STRETCH),
            Category(categoryName: "Cross-Train", symbol: "figure.cross.training", categoryColor: .CROSSTRAIN),
            Category(categoryName: "Power", symbol: "figure.strengthtraining.traditional", categoryColor: .POWER),
            Category(categoryName: "Pilates", symbol: "figure.pilates", categoryColor: .PILATES),
            Category(categoryName: "Cardio", symbol: "figure.mixed.cardio", categoryColor: .CARDIO),
            Category(categoryName: "Test", symbol: "stopwatch", categoryColor: .TEST),
            Category(categoryName: "Hiking", symbol: "figure.hiking", categoryColor: .HIKING),
            Category(categoryName: "Rowing", symbol: "figure.outdoor.rowing", categoryColor: .ROWING)
        ]
        
        for category in defaults {
            context.insert(category)
        }
        
        do {
            try context.save()
            logger.info("Default categories seeded successfully")
        } catch {
            logger.error("Failed to seed defaults: \(error)")
        }
    }
}
