//
//  PopcornTVListingsFactory.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsApplication

///
/// Public entry point for the TV listings context.
///
public protocol PopcornTVListingsFactory: Sendable {

    func makeSyncTVListingsUseCase() -> SyncTVListingsUseCase

    func makeFetchTVChannelsUseCase() -> FetchTVChannelsUseCase

    func makeFetchTVChannelScheduleUseCase() -> FetchTVChannelScheduleUseCase

    func makeFetchNowPlayingTVProgrammesUseCase() -> FetchNowPlayingTVProgrammesUseCase

}
