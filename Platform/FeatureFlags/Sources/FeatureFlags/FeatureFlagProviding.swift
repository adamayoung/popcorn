//
//  FeatureFlagProviding.swift
//  FeatureFlags
//
//  Created by Adam Young on 26/11/2025.
//

import Foundation

public protocol FeatureFlagProviding: Sendable {

    func isEnabled(_ key: String) -> Bool

}
