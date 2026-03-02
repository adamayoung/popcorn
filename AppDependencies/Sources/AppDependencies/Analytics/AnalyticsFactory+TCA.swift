//
//  AnalyticsFactory+TCA.swift
//  AppDependencies
//
//  Copyright © 2026 Adam Young.
//

import Analytics
import AnalyticsAdapters
import ComposableArchitecture
import Foundation

extension DependencyValues {

    var analyticsFactory: AnalyticsFactory {
        AnalyticsAdaptersFactory().makeAnalyticsFactory()
    }

}
