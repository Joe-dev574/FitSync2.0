//
//  Workout.swift
//  FitSync2.0
//
//  Created by Joseph DeWeese on 12/4/25.
//

import SwiftUI
import SwiftData
import OSLog

@Model
final class Workout {
    var id: UUID = UUID()

    var title: String = "New Workout"
    var lastSessionDuration: Double = 0.0
    var dateCreated: Date = Date()
    var dateCompleted: Date?
    var category: String = "General"  // Replaced Category? with String

    var roundsEnabled: Bool = false
    var roundsQuantity: Int = 1

    var fastestTime: Double?
    var generatedSummary: String?

    // CloudKit-safe relationships
    @Relationship(deleteRule: .cascade, inverse: \Exercise.workout)
    var exercises: [Exercise]? = []

    @Relationship(deleteRule: .cascade, inverse: \JournalEntry.workout)
    var history: [JournalEntry]? = []

    @Transient
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.tnt.pulsesplit",
        category: "Workout"
    )

    // Your beautiful computed properties — 100% preserved
    var sortedExercises: [Exercise] {
        (exercises ?? []).sorted { $0.order < $1.order }
    }

    init(
        title: String = "New Workout",
        exercises: [Exercise] = [],
        dateCreated: Date = .now,
        dateCompleted: Date? = nil,
        category: String = "General",
        roundsEnabled: Bool = false,
        roundsQuantity: Int = 1
    ) {
        self.title = title
        self.exercises = exercises
        self.dateCreated = dateCreated
        self.dateCompleted = dateCompleted
        self.category = category
        self.roundsEnabled = roundsEnabled
        self.roundsQuantity = roundsQuantity
    }

    /// Updates the generated summary based on the workout’s history.
    func updateSummary(context: ModelContext) {
        logger.info("Updating summary for workout: \(self.title)")
        guard ((history?.isEmpty) != nil) else {
            generatedSummary = nil
            logger.info("History is empty, generatedSummary set to nil.")
            return
        }

    }
}
        
