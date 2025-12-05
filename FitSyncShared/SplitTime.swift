//
//  SplitTime.swift
//  FitSync2.0
//
//  Created by Joseph DeWeese on 12/4/25.
//

import SwiftData
import Foundation

@Model
final class SplitTime {
    var id: UUID = UUID()
    
    var durationInSeconds: Double = 0.0        // Required: default
    var order: Int = 0                         // Required: default
    
    // Optional relationships with proper inverses
    @Relationship(inverse: \Exercise.splitTimes)
    var exercise: Exercise?
    
    @Relationship(inverse: \JournalEntry.splitTimes)
    var history: JournalEntry?
    
    init(durationInSeconds: Double = 0.0, order: Int = 0) {
        self.durationInSeconds = durationInSeconds
        self.order = order
    }
}
