//
//  AuthenticationView.swift
//  FitSync2.0
//
//  Created by Joseph DeWeese on 12/3/25.
//

import SwiftUI
import AuthenticationServices

struct AuthenticationView: View {
    @Environment(AuthenticationManager.self) private var auth
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            Color.blue.opacity(0.1).ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                Image(systemName: "figure.run.circle.fill")
                    .font(.system(size: 100))
                    .foregroundStyle(.blue)
                
                Text("Welcome to FitSync")
                    .font(.largeTitle).bold()
                
                Text("Sign in to track workouts and progress.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
                
                SignInWithAppleButton(
                    onRequest: auth.handleSignInWithAppleRequest,
                    onCompletion: { result in
                        Task { await auth.handleSignInWithAppleCompletion(result) }
                    }
                )
                .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
                .frame(height: 50)
                .padding(.horizontal, 50)
                
                Spacer()
            }
        }
        
    }
}
