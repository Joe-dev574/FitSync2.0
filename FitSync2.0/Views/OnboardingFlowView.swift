//
//  OnboardingFlowView.swift
//  FitSync2.0
//
//  Created by Joseph DeWeese on 12/4/25.
//

import SwiftUI
import SwiftData

struct OnboardingFlowView: View {
    @Environment(AuthenticationManager.self) private var auth
    @Environment(\.modelContext) private var context
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Text("Welcome to FitSync!")
                .font(.largeTitle).bold()
            
            VStack(spacing: 20) {
                Label("Create custom workouts", systemImage: "pencil")
                Label("Track HR zones privately", systemImage: "heart")
                Label("Apple Watch premium control", systemImage: "applewatch")
            }
            .font(.title3)
            
            Spacer()
            
            Button("Get Started") {
                auth.currentUser?.isOnboardingComplete = true
                try? context.save()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.horizontal, 40)
        }
    }
}
