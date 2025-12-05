//
//  OnboardingFlowView.swift
//  FitSync2.0
//
//  Created by Joseph DeWeese on 12/4/25.
//

import SwiftUI
import SwiftData
import OSLog

struct OnboardingFlowView: View {
    @Environment(AuthenticationManager.self) private var auth
    @Environment(\.modelContext) private var context
    @AppStorage("selectedThemeColorData") private var selectedThemeColorData: String = "#0096FF"
    
    private var themeColor: Color { Color(hex: selectedThemeColorData) ?? .blue }
    private let logger = Logger(subsystem: "com.tnt.FitSync2_0", category: "OnboardingView")
    
    @State private var showPremiumTeaser = false
    
    var body: some View {
        ZStack {
            // Enhanced blue gradient background: light and inviting, not dark
            LinearGradient(gradient: Gradient(colors: [themeColor.opacity(0.15), themeColor.opacity(0.05).mixed(with: .blue.opacity(0.8), by: 0.3), Color.clear]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                // Icons row with polished styling and animation
                HStack(spacing: 20) {
                    Image(systemName: "stopwatch.fill")
                        .font(.system(size: 50))
                        .foregroundStyle(themeColor)
                        .shadow(color: .black.opacity(0.1), radius: 4)
                    Image(systemName: "flame.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(themeColor)
                        .shadow(color: .black.opacity(0.1), radius: 4)
                    Image(systemName: "applewatch")
                        .font(.system(size: 50))
                        .foregroundStyle(themeColor)
                        .shadow(color: .black.opacity(0.1), radius: 4)
                }
                .padding(.bottom, 24)
                .accessibilityHidden(true)
                .scaleEffect(1.0) // Placeholder for animation
                .animation(.easeInOut(duration: 0.6), value: true)
                
                // Welcome text with increased size and Dynamic Type support
                Text("Welcome to FitSync!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(themeColor)
                    .accessibilityHint("Introduction to the FitSync app.")
                
                // Feature list with aligned icons and improved spacing
                VStack(alignment: .leading, spacing: 16) {
                    FeatureItem(icon: "pencil.and.outline", text: "Create custom workouts with splits and rounds.")
                    FeatureItem(icon: "chart.line.uptrend.xyaxis", text: "Track HR zones, calories, and trends privately.")
                    FeatureItem(icon: "applewatch", text: "Upgrade to premium for Apple Watch control.")
                }
                .padding(.horizontal, 40)
                .accessibilityElement(children: .combine)
                .accessibilityLabel("FitSync features: Create custom workouts, track HR zones, and upgrade for Watch control.")
                
                Spacer()
                
                // Get Started button with professional styling
                Button {
                    showPremiumTeaser = true  // Show premium teaser
                } label: {
                    Text("Get Started")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(themeColor)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
                .accessibilityLabel("Get Started")
                .accessibilityHint("Double-tap to complete onboarding and begin using the app.")
                .accessibilityAddTraits(.isButton)
            }
            .padding(.top, 60)
            .sheet(isPresented: $showPremiumTeaser, onDismiss: {
                auth.currentUser?.isOnboardingComplete = true
                try? context.save()
                logger.info("Onboarding completed")
            }) {
                NavigationStack {
                    PremiumTeaserView()
                }
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("FitSync onboarding screen")
        .accessibilityHint("Complete onboarding to start your workout journey.")
    }
}

// Helper view for feature items
struct FeatureItem: View {
    let icon: String
    let text: String
    @AppStorage("selectedThemeColorData") private var selectedThemeColorData: String = "#0096FF"
    
    private var themeColor: Color { Color(hex: selectedThemeColorData) ?? .blue }
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(themeColor)
                .font(.title3)
                .frame(width: 24, alignment: .leading)
            Text(text)
                .font(.body)
                .foregroundStyle(.primary)
        }
    }
}

// Enhanced PremiumTeaserView for professional appearance
struct PremiumTeaserView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: 24) {
            // Header with icon for visual appeal
            Image(systemName: "crown.fill")
                .font(.system(size: 50))
                .foregroundStyle(.yellow.opacity(0.9))
                .shadow(color: .black.opacity(0.1), radius: 4)
            
            Text("Unlock Premium Features")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
            
            VStack(alignment: .leading, spacing: 12) {
                PremiumFeature(text: "Independent Apple Watch sessions")
                PremiumFeature(text: "Haptic feedback and live heart rate monitoring")
                PremiumFeature(text: "Advanced analytics and custom themes")
            }
            .padding(.horizontal, 20)
            
            Text("Starting at $4.99 per month")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            // Call-to-action buttons
            NavigationLink(destination: SettingsView()) {
                Text("Learn More")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.1), radius: 6)
            }
            
            Button("Not Now") {
                dismiss()
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
        .padding(32)
        .background(colorScheme == .dark ? Color.gray.opacity(0.2) : Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 10)
        .padding(40)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Premium teaser: Unlock features like Apple Watch sessions for $4.99/month.")
        .accessibilityHint("Explore premium options or dismiss.")
    }
}

// Helper for premium features
struct PremiumFeature: View {
    let text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
            Text(text)
                .font(.body)
                .foregroundStyle(.primary)
        }
    }
}
