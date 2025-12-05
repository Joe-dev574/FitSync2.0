//
//  AuthenticationView.swift
//  FitSync2.0
//
//  Created by Joseph DeWeese on 12/3/25.
//

import SwiftUI
import AuthenticationServices
import OSLog

struct AuthenticationView: View {
    @Environment(AuthenticationManager.self) private var auth
    @Environment(\.colorScheme) private var colorScheme
    @AppStorage("selectedThemeColorData") private var selectedThemeColorData: String = "#0096FF"
    
    private var themeColor: Color { Color(hex: selectedThemeColorData) ?? .blue }
    
    var body: some View {
        ZStack {
            // Enhanced blue gradient background for a professional, subtle depth
            LinearGradient(gradient: Gradient(colors: [themeColor.opacity(0.1), themeColor.opacity(0.05).mixed(with: .blue, by: 0.5), Color.clear]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                // App logo with refined styling
                if let uiImage = UIImage(named: "FitSyncLogo") {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                        .accessibilityLabel("FitSync app icon")
                        .accessibilityHint("Represents the FitSync application logo.")
                        .accessibilityAddTraits(.isImage)
                } else {
                    Image(systemName: "stopwatch.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundStyle(themeColor)
                        .accessibilityLabel("Timer symbol")
                        .accessibilityHint("Placeholder icon for timing workouts.")
                        .accessibilityAddTraits(.isImage)
                }
                
                // Welcome text with increased size and Dynamic Type support
                Text("Welcome to FitSync")
                    .font(.largeTitle) // Supports Dynamic Type; equivalent to ~32pt base
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .accessibilityHint("Greeting for the authentication screen.")
                
                Text("Sign in to track your workouts and monitor progress securely.")
                    .font(.subheadline) // Supports Dynamic Type; equivalent to ~18pt base
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 40)
                    .accessibilityHint("Description of the app's purpose and sign-in action.")
                
                // Sign In button with custom styling
                SignInWithAppleButton(
                   
                    onRequest: auth.handleSignInWithAppleRequest,
                    onCompletion: { result in
                        Task { await auth.handleSignInWithAppleCompletion(result) }
                    }
                )
                .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
                .frame(height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                .padding(.horizontal, 40)
                .accessibilityHint("Tap to sign in using your Apple ID.")
                
                Spacer()
            }
            .padding(.vertical, 40)
            .animation(.easeInOut(duration: 0.5), value: true) // Subtle fade-in animation
            .accessibilityElement(children: .combine) // Groups content for efficient VoiceOver navigation
        }
    }
}

// Extension for Color mixing (used in gradient)
extension Color {
    func mixed(with other: Color, by percentage: Double) -> Color {
        let red1 = self.components.red
        let green1 = self.components.green
        let blue1 = self.components.blue
        let alpha1 = self.components.alpha
        
        let red2 = other.components.red
        let green2 = other.components.green
        let blue2 = other.components.blue
        let alpha2 = other.components.alpha
        
        return Color(
            red: red1 + (red2 - red1) * percentage,
            green: green1 + (green2 - green1) * percentage,
            blue: blue1 + (blue2 - blue1) * percentage,
            opacity: alpha1 + (alpha2 - alpha1) * percentage
        )
    }
    
    var components: (red: Double, green: Double, blue: Double, alpha: Double) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        UIColor(self).getRed(&r, green: &g, blue: &b, alpha: &a)
        return (Double(r), Double(g), Double(b), Double(a))
    }
}
