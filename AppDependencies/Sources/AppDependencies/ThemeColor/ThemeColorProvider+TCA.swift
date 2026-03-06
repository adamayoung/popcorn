//
//  ThemeColorProvider+TCA.swift
//  AppDependencies
//
//  Copyright © 2026 Adam Young.
//

import Caching
import ComposableArchitecture
import CoreDomain
import Foundation
import ThemeColorProvider

enum ThemeColorProviderKey: DependencyKey {

    static var liveValue: (any ThemeColorProviding)? {
        let cache = CachesFactory.makeDiskCache(subdirectory: "ThemeColors")
        return DefaultThemeColorProvider(cache: cache)
    }

}

extension DependencyValues {

    var themeColorProvider: (any ThemeColorProviding)? {
        get { self[ThemeColorProviderKey.self] }
        set { self[ThemeColorProviderKey.self] = newValue }
    }

}
