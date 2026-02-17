//
//  Observability+TCA.swift
//  AppDependencies
//
//  Copyright © 2026 Adam Young.
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

    var observability: any Observing {
        get { self[ObservabilityKey.self] }
        set { self[ObservabilityKey.self] = newValue }
    }

}
