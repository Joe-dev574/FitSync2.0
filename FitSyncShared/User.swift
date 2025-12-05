//
//  User.swift
//  FitSync2.0
//
//  Created by Joseph DeWeese on 12/4/25.
//

import SwiftData
import HealthKit  // For HKBiologicalSex mapping and health metric context


/// A SwiftData model representing a user's onboarding status and essential health metrics for PulseSplit.
/// Focuses on privacy: only stores Apple ID and optional HealthKit-derived data for personalization (e.g., HR zones).
@Model
final class User {
    // MARK: - Properties
    var appleUserId: String = ""  // Unique identifier from Sign in with Apple (mandatory)
    var isOnboardingComplete: Bool = false  // Tracks if onboarding (permissions, setup) is done

    // Optional identity/profile details
    var email: String?
    var displayName: String?
    var fitnessGoal: String?

    // Optional Health Metrics (pulled from HealthKit or user-entered)
    var weight: Double?  // in kg, for context in volume trends
    var height: Double?  // in cm, for VO2Max estimates
    var age: Int?  // For max HR calculation if not set
    var restingHeartRate: Double?  // in bpm, for recovery/readiness scores
    var maxHeartRate: Double?  // in bpm; user-entered or estimated (220 - age)
    var biologicalSex: BiologicalSex?  // Enum for HR zone personalization

    // MARK: - Initialization
    /// Designated initializer that ensures all stored properties are initialized.
    init(
        appleUserId: String,
        email: String? = nil,
        isOnboardingComplete: Bool = false,
        displayName: String? = nil,
        fitnessGoal: String? = "General Fitness",
        profileImageData: Data? = nil,
        biologicalSexString: String? = nil,
        weight: Double? = nil,
        height: Double? = nil,
        age: Int? = nil,
        restingHeartRate: Double? = nil,
        maxHeartRate: Double? = nil,
   
    ) {
        self.appleUserId = appleUserId
        self.email = email
        self.isOnboardingComplete = isOnboardingComplete
        self.displayName = displayName
        self.fitnessGoal = fitnessGoal
        self.weight = weight
        self.height = height
        self.age = age
        self.restingHeartRate = restingHeartRate
        self.maxHeartRate = maxHeartRate
        // Map incoming string (if provided) to BiologicalSex
        if let biologicalSexString = biologicalSexString, let sex = BiologicalSex(rawValue: biologicalSexString) {
            self.biologicalSex = sex
        } else {
            self.biologicalSex = nil
        }
    
    }

    // MARK: - Computed Properties
    /// Estimates max heart rate if not set (formula: 220 - age).
    var estimatedMaxHeartRate: Double? {
        guard let age = age else { return nil }
        return 220 - Double(age)
    }
}

// MARK: - BiologicalSex Enum (Simplified for PulseSplit)
enum BiologicalSex: String, Codable {
    case female = "Female"
    case male = "Male"
    case other = "Other"
    case notSet = "Not Set"

    init(hkSex: HKBiologicalSex) {
        switch hkSex {
        case .female: self = .female
        case .male: self = .male
        case .other: self = .other
        default: self = .notSet
        }
    }

    var hkValue: HKBiologicalSex {
        switch self {
        case .female: return .female
        case .male: return .male
        case .other: return .other
        case .notSet: return .notSet
        }
    }
}
