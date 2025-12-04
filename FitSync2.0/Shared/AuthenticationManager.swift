//
//  AuthenticationManager.swift
//  FitSync2.0
//
//  Created by Joseph DeWeese on 12/3/25.
//

import AuthenticationServices
import OSLog
import SwiftUI
import SwiftData

@Observable
 public final class AuthenticationManager {
    // MARK: - Public Published State (pure value types only!)
    var currentUser: User?
    var isSignedIn: Bool { currentUser != nil }
    
    // MARK: - Dependencies (injected, no HealthKit!)
    private let modelContainer: ModelContainer
    private let logger = Logger(subsystem: "com.tnt.FitSync", category: "Auth")
    
    // MARK: - Singleton (shared across app + Watch)
    static let shared = AuthenticationManager(
        modelContainer: FitSyncApp.container
    )
    
    private init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
        restoreSessionFromKeychain()
    }
    
    // MARK: - Public API
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
    }
    
    func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>) async {
        switch result {
        case .success(let auth):
            if let credential = auth.credential as? ASAuthorizationAppleIDCredential {
                await processCredential(credential)
            }
        case .failure(let error):
            if (error as? ASAuthorizationError)?.code != .canceled {
                ErrorManager.shared.present(error)
            }
        }
    }
    
    func signOut() {
        KeychainHelper.shared.delete(.appleUserID)
        currentUser = nil
        logger.info("User signed out")
    }
    
    // MARK: - Private: Session Restoration (FAST on launch)
    private func restoreSessionFromKeychain() {
        guard let appleUserId = KeychainHelper.shared.string(for: .appleUserID) else {
            return
        }
        
        Task { @MainActor in
            self.currentUser = await self.fetchUser(appleUserId: appleUserId)
            logger.info("Session restored for user: \(appleUserId.prefix(8))...")
        }
    }
    
    // MARK: - Private: Credential Processing
    private func processCredential(_ credential: ASAuthorizationAppleIDCredential) async {
        let appleUserId = credential.user
        
        // Save to Keychain (this is the source of truth!)
        KeychainHelper.shared.save(appleUserId, for: .appleUserID)
        
        // Fetch or create User in background
        let user = await fetchOrCreateUser(appleUserId: appleUserId, credential: credential)
        
        await MainActor.run {
            self.currentUser = user
            logger.info("Signed in as \(appleUserId.prefix(8))...")
        }
    }
    
    private func fetchOrCreateUser(appleUserId: String, credential: ASAuthorizationAppleIDCredential) async -> User {
        let context = ModelContext(modelContainer)
        
        let descriptor = FetchDescriptor<User>(
            predicate: #Predicate<User> { $0.appleUserId == appleUserId }
        )
        
        if let existing = try? context.fetch(descriptor).first {
            return existing
        }
        
        // Create new user
        let newUser = User(
            appleUserId: appleUserId,
            email: credential.email,
            displayName: credential.fullName?.formatted()
        )
        context.insert(newUser)
        try? context.save()
        return newUser
    }
    
    private func fetchUser(appleUserId: String) async -> User? {
        let context = ModelContext(modelContainer)
        let descriptor = FetchDescriptor<User>(
            predicate: #Predicate<User> { $0.appleUserId == appleUserId }
        )
        return try? context.fetch(descriptor).first
    }
}

