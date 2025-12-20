//
//  FeatureFlagging.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public protocol FeatureFlagging: Sendable {

    var isInitialised: Bool { get }

    func isEnabled(_ flag: FeatureFlag) -> Bool

    func isEnabled(_ key: some StringProtocol) -> Bool

}
