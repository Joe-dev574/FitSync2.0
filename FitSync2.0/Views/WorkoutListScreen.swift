//
//  WorkoutListScreen.swift
//  FitSync2.0
//
//  Created by Joseph DeWeese on 12/4/25.
//

import SwiftUI
import SwiftData

struct WorkoutListScreen: View {
    @Query(sort: \Workout.dateCreated, order: .reverse) private var workouts: [Workout]
    
    var body: some View {
        NavigationStack {
            List(workouts) { workout in
                NavigationLink(value: workout) {
                 
                }
            }
            .navigationTitle("My Workouts")
            
            }
            .toolbar {
                Button("New") {
                    // create new workout
                }
            }
        }
    }

