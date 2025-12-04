//
//  ContentView.swift
//  FitSync2.0
//
//  Created by Joseph DeWeese on 12/3/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(AuthenticationManager.self) private var auth
    
    var body: some View {
        NavigationStack {
            Group {
                if auth.isSignedIn {
                    if auth.currentUser?.isOnboardingComplete == true {
                        WorkoutListScreen()
                    } else {
                        OnboardingFlowView()
                    }
                } else {
                    AuthenticationView()
                }
            }
         
        }
    }
}
