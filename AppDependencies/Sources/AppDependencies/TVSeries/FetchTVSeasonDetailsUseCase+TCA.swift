//
//  FetchTVSeasonDetailsUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import TVSeriesApplication

enum FetchTVSeasonDetailsUseCaseKey: DependencyKey {

    static var liveValue: any FetchTVSeasonDetailsUseCase {
        @Dependency(\.tvSeriesFactory) var tvSeriesFactory
        return tvSeriesFactory.makeFetchTVSeasonDetailsUseCase()
    }

}

public extension DependencyValues {

    var fetchTVSeasonDetails: any FetchTVSeasonDetailsUseCase {
        get { self[FetchTVSeasonDetailsUseCaseKey.self] }
        set { self[FetchTVSeasonDetailsUseCaseKey.self] = newValue }
    }

}
