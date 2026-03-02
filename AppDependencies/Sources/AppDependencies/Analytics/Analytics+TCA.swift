//
//  Analytics+TCA.swift
//  AppDependencies
//
//  Copyright © 2026 Adam Young.
//

import Analytics
import ComposableArchitecture
import Foundation

enum AnalyticsKey: DependencyKey {

    static var liveValue: any Analysing {
        @Dependency(\.analyticsFactory) var analyticsFactory
        return analyticsFactory.makeService()
    }

}

public extension DependencyValues {

    var analytics: any Analysing {
        get { self[AnalyticsKey.self] }
        set { self[AnalyticsKey.self] = newValue }
    }

}
