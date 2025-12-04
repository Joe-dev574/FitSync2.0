//
//  Exercise.swift
//  FitSync2.0
//
//  Created by Joseph DeWeese on 12/4/25.
//

import SwiftData
import Foundation

@Model
final class Exercise {
    @Attribute(.unique) var id: UUID
    
    var name: String = "Exercise"
    var order: Int = 0
    
    // Non-optional array — always exists
    @Relationship(deleteRule: .cascade)
    var splitTimes: [SplitTime] = []
    
    // Proper bidirectional relationship
    @Relationship(deleteRule: .nullify)
    var workout: Workout?
    
    init(name: String = "New Exercise", order: Int = 0, workout: Workout? = nil) {
        self.id = UUID()
        self.name = name
        self.order = order
        self.workout = workout
    }
}



