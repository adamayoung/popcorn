//
//  FetchTVSeriesDetailsUseCase+TCA.swift
//  AppDependencies
//
//  Created by Adam Young on 18/11/2025.
//

import ComposableArchitecture
import Foundation
import TVSeriesApplication

enum FetchTVSeriesDetailsUseCaseKey: DependencyKey {

    static var liveValue: any FetchTVSeriesDetailsUseCase {
        @Dependency(\.tvSeriesFactory) var tvSeriesFactory
        return tvSeriesFactory.makeFetchTVSeriesDetailsUseCase()
    }

}

extension DependencyValues {

    public var fetchTVSeriesDetails: any FetchTVSeriesDetailsUseCase {
        get { self[FetchTVSeriesDetailsUseCaseKey.self] }
        set { self[FetchTVSeriesDetailsUseCaseKey.self] = newValue }
    }

}
