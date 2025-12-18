//
//  ObservabilityFactory+TCA.swift
//  AppDependencies
//
//  Created by Adam Young on 17/12/2025.
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
