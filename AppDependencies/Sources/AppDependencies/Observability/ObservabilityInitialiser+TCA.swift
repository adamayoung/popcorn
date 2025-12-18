//
//  ObservabilityInitialiser+TCA.swift
//  AppDependencies
//
//  Created by Adam Young on 17/12/2025.
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

extension DependencyValues {

    public var observabilityInitialiser: any ObservabilityInitialising {
        get { self[ObservabilityInitialiserKey.self] }
        set { self[ObservabilityInitialiserKey.self] = newValue }
    }

}
