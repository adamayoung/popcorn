//
//  Observability+TCA.swift
//  AppDependencies
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import Foundation
import Observability

enum ObservabilityKey: DependencyKey {

    static var liveValue: any Observing {
        @Dependency(\.observabilityFactory) var observabilityFactory
        return observabilityFactory.makeService()
    }

}

public extension DependencyValues {

    ///
    /// A service for error reporting and debugging context.
    ///
    /// Provides functionality for capturing errors and messages to monitoring
    /// services, setting user context, and adding breadcrumbs for debugging.
    ///
    var observability: any Observing {
        get { self[ObservabilityKey.self] }
        set { self[ObservabilityKey.self] = newValue }
    }

}
