//
//  AnalyticsInitialiser+TCA.swift
//  AppDependencies
//
//  Copyright © 2026 Adam Young.
//

import Analytics
import ComposableArchitecture
import Foundation

enum AnalyticsInitialiserKey: DependencyKey {

    static var liveValue: any AnalyticsInitialising {
        @Dependency(\.analyticsFactory) var analyticsFactory
        return analyticsFactory.makeService()
    }

}

public extension DependencyValues {

    var analyticsInitialiser: any AnalyticsInitialising {
        get { self[AnalyticsInitialiserKey.self] }
        set { self[AnalyticsInitialiserKey.self] = newValue }
    }

}
