//
//  ObservabilityInitialising.swift
//  Observability
//
//  Created by Adam Young on 16/12/2025.
//

import Foundation

public protocol ObservabilityInitialising: Sendable {

    func start(_ config: ObservabilityConfiguration) async throws

}
