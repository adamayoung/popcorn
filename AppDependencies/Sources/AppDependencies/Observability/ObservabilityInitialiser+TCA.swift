//
//  ObservabilityInitialiser+TCA.swift
//  AppDependencies
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import Foundation
import Observability

enum ObservabilityInitialiserKey: DependencyKey {

    static var liveValue: any ObservabilityInitialising {
        @Dependency(\.observabilityFactory) var observabilityFactory
        return observabilityFactory.makeService()
    }

}

public extension DependencyValues {

    ///
    /// A service for initialising the observability infrastructure.
    ///
    /// Configures and starts the observability system with the appropriate
    /// settings for the current environment.
    ///
    var observabilityInitialiser: any ObservabilityInitialising {
        get { self[ObservabilityInitialiserKey.self] }
        set { self[ObservabilityInitialiserKey.self] = newValue }
    }

}
