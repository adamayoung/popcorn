//
//  AnalyticsProviding.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public protocol AnalyticsProviding: Sendable {

    var isInitialised: Bool { get }

    func start(_ config: AnalyticsConfiguration) async throws

    func track(event: String, properties: [String: any Sendable]?)

    func setUserId(_ userId: String?)

    func setUserProperties(_ properties: [String: any Sendable])

    func reset()

}
