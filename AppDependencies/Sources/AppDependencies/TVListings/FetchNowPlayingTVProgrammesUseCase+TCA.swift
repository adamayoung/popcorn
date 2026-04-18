//
//  FetchNowPlayingTVProgrammesUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import TVListingsApplication

enum FetchNowPlayingTVProgrammesUseCaseKey: DependencyKey {

    static var liveValue: any FetchNowPlayingTVProgrammesUseCase {
        @Dependency(\.tvListingsFactory) var tvListingsFactory
        return tvListingsFactory.makeFetchNowPlayingTVProgrammesUseCase()
    }

}

public extension DependencyValues {

    var fetchNowPlayingTVProgrammes: any FetchNowPlayingTVProgrammesUseCase {
        get { self[FetchNowPlayingTVProgrammesUseCaseKey.self] }
        set { self[FetchNowPlayingTVProgrammesUseCaseKey.self] = newValue }
    }

}
