//
//  TVListingsFactory+TCA.swift
//  AppDependencies
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import PopcornTVListingsAdapters
import TVListingsComposition

enum PopcornTVListingsFactoryKey: DependencyKey {

    static var liveValue: any PopcornTVListingsFactory {
        @Dependency(\.tvListingsEPGURL) var epgURL
        return PopcornTVListingsAdaptersFactory(epgURL: epgURL).makeTVListingsFactory()
    }

}

extension DependencyValues {

    var tvListingsFactory: any PopcornTVListingsFactory {
        get { self[PopcornTVListingsFactoryKey.self] }
        set { self[PopcornTVListingsFactoryKey.self] = newValue }
    }

}
