//
//  FeatureFlagging.swift
//  FeatureAccess
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public protocol FeatureFlagging: Sendable {

    var isInitialised: Bool { get }

    func isEnabled(_ flag: FeatureFlag) -> Bool

}
