//
//  ObservabilityFactory+TCA.swift
//  AppDependencies
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import Observability
import ObservabilityAdapters

extension DependencyValues {

    var observabilityFactory: ObservabilityFactory {
        ObservabilityAdaptersFactory().makeObservabilityFactory()
    }

}
