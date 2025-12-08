//
//  FetchTVSeriesDetailsUseCase+TCA.swift
//  PopcornTVAdapters
//
//  Created by Adam Young on 18/11/2025.
//

import ComposableArchitecture
import Foundation
import TVApplication

enum FetchTVSeriesDetailsUseCaseKey: DependencyKey {

    static var liveValue: any FetchTVSeriesDetailsUseCase {
        DependencyValues._current
            .tvFactory
            .makeFetchTVSeriesDetailsUseCase()
    }

}

extension DependencyValues {

    public var fetchTVSeriesDetails: any FetchTVSeriesDetailsUseCase {
        get { self[FetchTVSeriesDetailsUseCaseKey.self] }
        set { self[FetchTVSeriesDetailsUseCaseKey.self] = newValue }
    }

}
