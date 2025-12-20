//
//  ObservabilityInitialising.swift
//  Observability
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public protocol ObservabilityInitialising: Sendable {

    func start(_ config: ObservabilityConfiguration) async throws

}
