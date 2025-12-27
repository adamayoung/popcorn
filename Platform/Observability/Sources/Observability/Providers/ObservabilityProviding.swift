//
//  ObservabilityProviding.swift
//  Observability
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public protocol ObservabilityProviding: Sendable {

    func start(_ config: ObservabilityConfiguration) async throws

    func capture(error: any Error)

    func capture(error: any Error, extras: [String: any Sendable])

    func capture(message: String)

    func setUser(id: String?, email: String?, username: String?)

    func addBreadcrumb(category: String, message: String)

}
