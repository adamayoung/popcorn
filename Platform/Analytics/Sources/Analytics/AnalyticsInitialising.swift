//
//  AnalyticsInitialising.swift
//  Analytics
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public protocol AnalyticsInitialising: Sendable {

    func start(_ config: AnalyticsConfiguration) async throws

}
