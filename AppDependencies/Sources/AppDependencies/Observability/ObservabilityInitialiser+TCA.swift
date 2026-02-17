//
//  ObservabilityInitialiser+TCA.swift
//  AppDependencies
//
//  Copyright © 2026 Adam Young.
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

    var observabilityInitialiser: any ObservabilityInitialising {
        get { self[ObservabilityInitialiserKey.self] }
        set { self[ObservabilityInitialiserKey.self] = newValue }
    }

}
