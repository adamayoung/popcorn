//
//  SyncTVListingsUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import TVListingsApplication

enum SyncTVListingsUseCaseKey: DependencyKey {

    static var liveValue: any SyncTVListingsUseCase {
        @Dependency(\.tvListingsFactory) var tvListingsFactory
        return tvListingsFactory.makeSyncTVListingsUseCase()
    }

}

public extension DependencyValues {

    var syncTVListings: any SyncTVListingsUseCase {
        get { self[SyncTVListingsUseCaseKey.self] }
        set { self[SyncTVListingsUseCaseKey.self] = newValue }
    }

}
