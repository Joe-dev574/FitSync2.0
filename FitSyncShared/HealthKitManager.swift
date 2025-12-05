//
//  HealthKitManager.swift
//  FitSync2.0
//
//  Created by Joseph DeWeese on 12/4/25.
//

import HealthKit
import OSLog
import SwiftUI


@Observable
public final class HealthKitManager {
    static let shared = HealthKitManager()
    
    let healthStore = HKHealthStore()
    private let logger = Logger(subsystem: "com.tnt.FitSync", category: "HealthKit")
    
    // MARK: - Observable State
    var isAuthorized = false
    var authorizationStatus: AuthorizationStatus = .notDetermined
    
    enum AuthorizationStatus {
        case notDetermined, authorized, denied, unavailable
    }
    
    private var currentAppleUserId: String?
    
    private init() {
        updateAuthorizationStatus()
    }
    
    // MARK: - User ID
    func setCurrentAppleUserId(_ appleUserId: String?) {
        self.currentAppleUserId = appleUserId
    }
    
    // MARK: - HealthKit Types (unchanged — perfect)
    private var typesToRead: Set<HKObjectType> {
        Set([
            HKQuantityType(.heartRate),
            HKQuantityType(.activeEnergyBurned),
            HKQuantityType(.distanceWalkingRunning),
            HKQuantityType(.distanceCycling),
            HKQuantityType(.distanceSwimming),
            HKQuantityType(.restingHeartRate),
            HKObjectType.workoutType(),
        ])
    }
    private var typesToWrite: Set<HKSampleType> {
        Set([
            HKObjectType.workoutType(),
            HKQuantityType(.activeEnergyBurned),
            HKQuantityType(.distanceWalkingRunning),
            HKQuantityType(.distanceCycling),
            HKQuantityType(.distanceSwimming),
        ])
        
    }
    
    // MARK: - Authorization
    func updateAuthorizationStatus() {
        guard HKHealthStore.isHealthDataAvailable() else {
            authorizationStatus = .unavailable
            isAuthorized = false
            return
        }
        
        let allTypes = typesToRead.union(typesToWrite as Set<HKObjectType>)
        let statuses = allTypes.map { healthStore.authorizationStatus(for: $0) }
        
        if statuses.allSatisfy({ $0 == .sharingAuthorized }) {
            authorizationStatus = .authorized
            isAuthorized = true
        } else if statuses.contains(.sharingDenied) {
            authorizationStatus = .denied
            isAuthorized = false
        } else {
            authorizationStatus = .notDetermined
            isAuthorized = false
        }
    }
    
    func requestAuthorization() async throws {
        guard HKHealthStore.isHealthDataAvailable() else {
            throw AppError.healthKitUnavailable
        }
        logger.info("Requesting HealthKit permissions...")
        try await healthStore.requestAuthorization(toShare: typesToWrite, read: typesToRead)
        try await Task.sleep(for: .milliseconds(300))
        updateAuthorizationStatus()
        
        let denied = (typesToRead.union(typesToWrite as Set<HKObjectType>))
            .filter { healthStore.authorizationStatus(for: $0) == .sharingDenied }
        
        if !denied.isEmpty {
            ErrorManager.shared.present(
                AppError.healthKitNotAuthorized,
                secondaryButton: .default(Text("Open Settings")) {
#if os(iOS)
                    self.openSettings()
#endif
                }
            )
        }
    }
    
#if os(iOS)
    func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
#endif
    
    // MARK: - iPhone Live Workout (Freemium)
    func startLiveWorkout_iPhone(
        activityType: HKWorkoutActivityType,
        locationType: HKWorkoutSessionLocationType = .unknown
    ) async throws -> HKWorkoutBuilder {
        guard isAuthorized else { throw AppError.healthKitNotAuthorized }
        
        let config = HKWorkoutConfiguration()
        config.activityType = activityType
        config.locationType = locationType
        
        let builder = HKWorkoutBuilder(healthStore: healthStore, configuration: config, device: .local())
        
        // CORRECT: Use the new async API (your fix was perfect!)
        try await builder.beginCollection(at: Date())
        
        logger.info("Live workout started: \(activityType.name)")
        return builder
    }
    
#if os(watchOS)
    func startLiveWorkout_Watch(
        activityType: HKWorkoutActivityType,
        locationType: HKWorkoutSessionLocationType = .unknown
    ) async throws -> HKWorkoutSession {
        guard isAuthorized else { throw AppError.healthKitNotAuthorized }
        
        let config = HKWorkoutConfiguration()
        config.activityType = activityType
        config.locationType = locationType
        
        let session = try HKWorkoutSession(healthStore: healthStore, configuration: config)
        session.startActivity(with: Date())
        
        logger.info("Watch workout started: \(activityType.name)")
        return session
    }
#endif
    
    // MARK: - End Workout
    func endLiveWorkout(
        builder: HKWorkoutBuilder,
        endDate: Date = .now,
        metadata: [String: Any]? = nil
    ) async throws -> HKWorkout {
        try await withCheckedThrowingContinuation {
            (continuation: CheckedContinuation<Void, Error>) in
            builder.endCollection(withEnd: endDate) { success, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if success {
                    continuation.resume(returning: ())
                } else {
                    continuation.resume(throwing: AppError.unknown(nil))
                }
            }
        }
        let workout = try await withCheckedThrowingContinuation {
            (continuation: CheckedContinuation<HKWorkout, Error>) in
            builder.finishWorkout() { workout, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let workout = workout {
                    continuation.resume(returning: workout)
                } else {
                    continuation.resume(throwing: AppError.unknown(nil))
                }
            }
        }
        logger.info("Workout saved to HealthKit: (workout.uuid)")
        return workout
    }
}

// MARK: - Helper Extension (add this anywhere)
extension HKWorkoutActivityType {
    var name: String {
        switch self {
        case .running: return "Running"
        case .walking: return "Walking"
        case .cycling: return "Cycling"
        case .swimming: return "Swimming"
        case .yoga: return "Yoga"
        case .traditionalStrengthTraining: return "Strength Training"
        case .hiking: return "Hiking"
        case .rowing: return "Rowing"
        case .elliptical: return "Elliptical"
        case .highIntensityIntervalTraining: return "HIIT"
        case .mindAndBody: return "Mind & Body"
        default: return "Workout"
        }
    }
}


