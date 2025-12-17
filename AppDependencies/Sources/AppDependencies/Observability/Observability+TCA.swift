//
//  Observability+TCA.swift
//  AppDependencies
//
//  Created by Adam Young on 17/12/2025.
//

import ComposableArchitecture
import Foundation
import Observability

enum ObservabilityKey: DependencyKey {

    static var liveValue: any Observability {
        @Dependency(\.observabilityFactory) var observabilityFactory
        return observabilityFactory.makeService()
    }

}

extension DependencyValues {

    public var observability: any Observability {
        get { self[ObservabilityKey.self] }
        set { self[ObservabilityKey.self] = newValue }
    }

}
