//
//  FetchTVChannelScheduleUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import TVListingsApplication

enum FetchTVChannelScheduleUseCaseKey: DependencyKey {

    static var liveValue: any FetchTVChannelScheduleUseCase {
        @Dependency(\.tvListingsFactory) var tvListingsFactory
        return tvListingsFactory.makeFetchTVChannelScheduleUseCase()
    }

}

public extension DependencyValues {

    var fetchTVChannelSchedule: any FetchTVChannelScheduleUseCase {
        get { self[FetchTVChannelScheduleUseCaseKey.self] }
        set { self[FetchTVChannelScheduleUseCaseKey.self] = newValue }
    }

}
