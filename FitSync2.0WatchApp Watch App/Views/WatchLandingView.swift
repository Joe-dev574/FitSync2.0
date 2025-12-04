//
//  WatchLandingView.swift
//  FitSync2.0WatchApp Watch App
//
//  Created by Joseph DeWeese on 12/4/25.
//

import SwiftUI


struct WatchLandingView: View {
    @Environment(AuthenticationManager.self) private var auth
    @Environment(HealthKitManager.self) private var healthKit
    
    var body: some View {
        if auth.isSignedIn {
            WatchWorkoutListView()           // Straight to workouts
        } else {
            WatchSignInView()                 // One-tap Apple sign-in (no onboarding!)
        }
    }
}
