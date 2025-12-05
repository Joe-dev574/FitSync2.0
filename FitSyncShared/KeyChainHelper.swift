//
//  KeyChainHelper.swift
//  FitSync2.0
//
//  Created by Joseph DeWeese on 12/4/25.
//

import Foundation

// KeychainHelper.swift
enum KeychainKey: String {
    case appleUserID
}

struct KeychainHelper {
    static let shared = KeychainHelper()
    private init() {}
    
    func save(_ value: String, for key: KeychainKey) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecValueData as String: value.data(using: .utf8)!
        ]
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
    
    func string(for key: KeychainKey) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecReturnData as String: true
        ]
        var result: AnyObject?
        SecItemCopyMatching(query as CFDictionary, &result)
        guard let data = result as? Data, let string = String(data: data, encoding: .utf8) else { return nil }
        return string
    }
    
    func delete(_ key: KeychainKey) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue
        ]
        SecItemDelete(query as CFDictionary)
    }
}

