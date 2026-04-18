//
//  FetchTVChannelsUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import TVListingsApplication

enum FetchTVChannelsUseCaseKey: DependencyKey {

    static var liveValue: any FetchTVChannelsUseCase {
        @Dependency(\.tvListingsFactory) var tvListingsFactory
        return tvListingsFactory.makeFetchTVChannelsUseCase()
    }

}

public extension DependencyValues {

    var fetchTVChannels: any FetchTVChannelsUseCase {
        get { self[FetchTVChannelsUseCaseKey.self] }
        set { self[FetchTVChannelsUseCaseKey.self] = newValue }
    }

}
