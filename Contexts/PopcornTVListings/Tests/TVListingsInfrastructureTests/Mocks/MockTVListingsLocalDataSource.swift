//
//  MockTVListingsLocalDataSource.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain
@testable import TVListingsInfrastructure

actor MockTVListingsLocalDataSource: TVListingsLocalDataSource {

    var channelsStub: Result<[TVChannel], TVListingsLocalDataSourceError> = .success([])
    var channelsCallCount = 0

    var programmesStub: Result<[TVProgramme], TVListingsLocalDataSourceError> = .success([])
    var programmesCallCount = 0
    var programmesCalledWith: [(channelID: String, date: Date)] = []

    var nowPlayingStub: Result<[TVProgramme], TVListingsLocalDataSourceError> = .success([])
    var nowPlayingCallCount = 0
    var nowPlayingCalledWith: [Date] = []

    var replaceAllStub: Result<Void, TVListingsLocalDataSourceError> = .success(())
    var replaceAllCallCount = 0
    var replaceAllCalledWith: [(channels: [TVChannel], programmes: [TVProgramme])] = []

    func channels() async throws(TVListingsLocalDataSourceError) -> [TVChannel] {
        channelsCallCount += 1
        switch channelsStub {
        case .success(let channels): return channels
        case .failure(let error): throw error
        }
    }

    func programmes(
        forChannelID channelID: String,
        onDate date: Date
    ) async throws(TVListingsLocalDataSourceError) -> [TVProgramme] {
        programmesCallCount += 1
        programmesCalledWith.append((channelID, date))
        switch programmesStub {
        case .success(let programmes): return programmes
        case .failure(let error): throw error
        }
    }

    func nowPlayingProgrammes(
        at date: Date
    ) async throws(TVListingsLocalDataSourceError) -> [TVProgramme] {
        nowPlayingCallCount += 1
        nowPlayingCalledWith.append(date)
        switch nowPlayingStub {
        case .success(let programmes): return programmes
        case .failure(let error): throw error
        }
    }

    func replaceAll(
        channels: [TVChannel],
        programmes: [TVProgramme]
    ) async throws(TVListingsLocalDataSourceError) {
        replaceAllCallCount += 1
        replaceAllCalledWith.append((channels, programmes))
        switch replaceAllStub {
        case .success: return
        case .failure(let error): throw error
        }
    }

}
