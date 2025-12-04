//
//  User.swift
//  FitSync2.0
//
//  Created by Joseph DeWeese on 12/4/25.
//

import SwiftData



/// SwiftData model – guaranteed to sync perfectly with iCloud private database
@Model
final class User {
    // MARK: - Required
    @Attribute(.unique) var appleUserId: String
    
    // MARK: - Onboarding & UI flags
    var isOnboardingComplete: Bool = false
    
    // MARK: - Optional profile
    var email: String?
    var displayName: String?
    var fitnessGoal: String?
    
    // MARK: - Optional health metrics (user-entered or pulled later from HealthKit)
    var weightKg: Double?
    var heightCm: Double?
    var age: Int?
    var restingHeartRate: Double?
    var maxHeartRate: Double?
   
    
    // MARK: - Initialization (perfect for SwiftData insertion)
    init(
        appleUserId: String,
        email: String? = nil,
        displayName: String? = nil,
        fitnessGoal: String? = "General Fitness",
        weightKg: Double? = nil,
        heightCm: Double? = nil,
        age: Int? = nil,
        restingHeartRate: Double? = nil,
        maxHeartRate: Double? = nil,
        isOnboardingComplete: Bool = false
    ) {
        self.appleUserId = appleUserId
        self.email = email
        self.displayName = displayName
        self.fitnessGoal = fitnessGoal
        self.weightKg = weightKg
        self.heightCm = heightCm
        self.age = age
        self.restingHeartRate = restingHeartRate
        self.maxHeartRate = maxHeartRate
        self.isOnboardingComplete = isOnboardingComplete
    }
    
    // MARK: - Computed Helpers (safe to use in UI)
    var estimatedMaxHeartRate: Double? {
        guard let age = age else { return nil }
        return 220 - Double(age)
    }
    
    var effectiveMaxHeartRate: Double {
        maxHeartRate ?? estimatedMaxHeartRate ?? 200
    }
}

