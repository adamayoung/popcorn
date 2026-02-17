//
//  AppInstallationIdentifier.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

enum AppInstallationIdentifier {

    private static let userDefaultsKey = "popcorn.installation_identifier"

    static func userID() -> String {
        let userDefaults = UserDefaults.standard
        if let existing = userDefaults.string(forKey: userDefaultsKey),
           !existing.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return existing
        }

        let newValue = UUID().uuidString
        userDefaults.set(newValue, forKey: userDefaultsKey)
        return newValue
    }

}
