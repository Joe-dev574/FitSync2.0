//
//  Workout.swift
//  FitSync2.0
//
//  Created by Joseph DeWeese on 12/4/25.
//

import SwiftData
import Foundation

@Model
final class Workout {
    @Attribute(.unique) var id: UUID = UUID()
    
    var title: String
    var lastSessionDuration: TimeInterval = 0
    var dateCreated: Date = Date()
    var dateCompleted: Date?
    
    // Proper relationship — gives you color, MET, HK type for free
    var category: String = "Power"
    
    // Rounds mode
    var roundsEnabled: Bool = false
    var roundsQuantity: Int = 1
    
    // Stats
    var fastestTime: TimeInterval?
    var generatedSummary: String?
    
    // Relationships — non-optional, cascade delete
    @Relationship(deleteRule: .cascade, inverse: \Exercise.workout)
    var exercises: [Exercise] = []
    
    @Relationship(deleteRule: .cascade, inverse: \JournalEntry.workout)
    var jornalEntry: [JournalEntry] = []
    
    // MARK: - Computed
    var sortedExercises: [Exercise] {
        exercises.sorted { $0.order < $1.order }
    }
    
    init(
        title: String = "New Workout",
        category: String = "POWER",
        dateCreated: Date = .now,
        roundsEnabled: Bool = false,
        roundsQuantity: Int = 1
    ) {
        self.id = UUID()
        self.title = title
        self.category = category
        self.dateCreated = dateCreated
        self.roundsEnabled = roundsEnabled
        self.roundsQuantity = roundsQuantity
    }
}



