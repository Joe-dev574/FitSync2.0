//
//  Category.swift
//  FitSync2.0
//
//  Created by Joseph DeWeese on 12/4/25.
//

import SwiftUI
import SwiftData

// MARK: - Pure Swift enum – no HealthKit anywhere
enum CategoryColor: String, Codable, CaseIterable {
    case CARDIO, CROSSTRAIN, CYCLING, GRAPPLING, HIIT, HIKING, PILATES,
         POWER, RECOVERY, ROWING, RUN, STRETCH, STRENGTH, SWIMMING,
         TEST, WALK, YOGA
    
    var color: Color { Color(self.rawValue) }
    
    // Pure Swift mapping – HealthKit stays OUT of the model
    var hkActivityTypeRawValue: UInt {
        switch self {
        case .CARDIO:       return 3000 // .mixedCardio
        case .CROSSTRAIN:   return 11   // .crossTraining
        case .CYCLING:      return 9
        case .GRAPPLING:    return 39   // .martialArts
        case .HIIT:         return 37   // .highIntensityIntervalTraining
        case .HIKING:       return 27
        case .PILATES:      return 41
        case .POWER:        return 56   // .traditionalStrengthTraining
        case .RECOVERY:     return 18   // .flexibility
        case .ROWING:       return 45
        case .RUN:          return 47
        case .STRETCH:      return 18   // .flexibility
        case .STRENGTH:     return 56
        case .SWIMMING:     return 53
        case .TEST:         return 3000 // .other
        case .WALK:         return 61
        case .YOGA:         return 66
        }
    }
    
    var metValue: Double {
        switch self {
        case .CARDIO: 8.0; case .CROSSTRAIN: 8.0; case .CYCLING: 8.0
        case .GRAPPLING: 10.3; case .HIIT: 8.0; case .HIKING: 7.3
        case .PILATES: 3.0; case .POWER: 6.0; case .RECOVERY: 2.5
        case .ROWING: 7.0; case .RUN: 10.0; case .STRETCH: 2.3
        case .STRENGTH: 3.5; case .SWIMMING: 6.0; case .TEST: 5.0
        case .WALK: 3.5; case .YOGA: 3.0
        }
    }
}

@Model
final class Category: Identifiable {
    @Attribute(.unique) var categoryName: String
    var symbol: String
    var categoryColor: CategoryColor
    
    init(categoryName: String, symbol: String, categoryColor: CategoryColor = .STRENGTH) {
        self.categoryName = categoryName.trimmingCharacters(in: .whitespacesAndNewlines)
        self.symbol = symbol
        self.categoryColor = categoryColor
        
        guard !self.categoryName.isEmpty else {
            fatalError("Category name cannot be empty")
        }
    }
}
