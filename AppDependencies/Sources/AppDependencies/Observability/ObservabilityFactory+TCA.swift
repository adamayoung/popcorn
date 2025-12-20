//
//  ObservabilityFactory+TCA.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
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
