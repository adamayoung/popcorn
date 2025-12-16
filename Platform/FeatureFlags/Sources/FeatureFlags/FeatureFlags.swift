//
//  FeatureFlags.swift
//  FeatureFlags
//
//  Created by Adam Young on 16/12/2025.
//

import Foundation

public protocol FeatureFlags: Sendable {

    func isEnabled(_ flag: FeatureFlag) -> Bool

    func isEnabled(_ key: some StringProtocol) -> Bool

}
