//
//  TVListingsEPGURL+TCA.swift
//  AppDependencies
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import PopcornTVListingsAdapters

enum TVListingsEPGURLKey: DependencyKey {

    static var liveValue: URL {
        HTTPTVListingsRemoteDataSource.defaultEPGURL
    }

}

public extension DependencyValues {

    var tvListingsEPGURL: URL {
        get { self[TVListingsEPGURLKey.self] }
        set { self[TVListingsEPGURLKey.self] = newValue }
    }

}
