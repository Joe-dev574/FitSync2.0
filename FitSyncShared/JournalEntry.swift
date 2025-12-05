//
//  JournalEntry.swift
//  FitSync2.0
//
//  Created by Joseph DeWeese on 12/4/25.
//

import SwiftUI
import SwiftData

@Model
final class JournalEntry {
    var id: UUID = UUID()
    
    var date: Date = Date()
    var lastSessionDuration: Double = 0.0
    var notes: String?
    
    // Removed exercisesCompleted — not needed (you already have splitTimes)
    // If you want it later, make it @Relationship with inverse
    
    @Relationship(deleteRule: .cascade)
    var splitTimes: [SplitTime]? = []
    
    @Relationship(deleteRule: .nullify)
    var workout: Workout?
    
    var intensityScore: Double?
    var progressPulseScore: Double?
    var dominantZone: Int?
    
    init(
        date: Date = .now,
        lastSessionDuration: Double = 0.0,
        notes: String? = nil,
        intensityScore: Double? = nil,
        progressPulseScore: Double? = nil,
        dominantZone: Int? = nil
    ) {
        self.date = date
        self.lastSessionDuration = lastSessionDuration
        self.notes = notes
        self.intensityScore = intensityScore
        self.progressPulseScore = progressPulseScore
        self.dominantZone = dominantZone
    }
}
