//
//  TVListingsFeatureBuildItemsTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import Testing
import TVListingsDomain
@testable import TVListingsFeature

@MainActor
@Suite("TVListingsFeature buildItems")
struct TVListingsFeatureBuildItemsTests {

    @Test("fetch produces one item per programme when a channel has multiple programmes")
    func fetchProducesItemPerProgrammeForChannelWithMultipleProgrammes() async {
        let bbcOne = TVListingsFixtures.makeChannel(id: "BBC_ONE", name: "BBC One")
        let news = TVListingsFixtures.makeProgramme(id: "BBC_ONE:1", channelID: "BBC_ONE", title: "News")
        let weather = TVListingsFixtures.makeProgramme(id: "BBC_ONE:2", channelID: "BBC_ONE", title: "Weather")
        let store = TestStore(initialState: TVListingsFeature.State()) {
            TVListingsFeature()
        } withDependencies: {
            $0.tvListingsClient.fetchChannels = { [bbcOne] }
            $0.tvListingsClient.fetchNowPlayingProgrammes = { [news, weather] }
        }

        await store.send(.fetch) {
            $0.viewState = .loading
        }
        await store.receive(\.nowPlayingLoaded) {
            $0.viewState = .ready(
                TVListingsFeature.ViewSnapshot(
                    items: [
                        TVListingsFeature.NowPlayingItem(channel: bbcOne, programme: news),
                        TVListingsFeature.NowPlayingItem(channel: bbcOne, programme: weather)
                    ]
                )
            )
        }
    }

    @Test("fetch drops programmes whose channel is absent from the channel list")
    func fetchDropsProgrammesWithoutMatchingChannel() async {
        let bbcOne = TVListingsFixtures.makeChannel(id: "BBC_ONE", name: "BBC One")
        let bbcOneProgramme = TVListingsFixtures.makeProgramme(id: "BBC_ONE:1", channelID: "BBC_ONE", title: "News")
        let orphan = TVListingsFixtures.makeProgramme(id: "ITV:1", channelID: "ITV", title: "Weather")
        let store = TestStore(initialState: TVListingsFeature.State()) {
            TVListingsFeature()
        } withDependencies: {
            $0.tvListingsClient.fetchChannels = { [bbcOne] }
            $0.tvListingsClient.fetchNowPlayingProgrammes = { [bbcOneProgramme, orphan] }
        }

        await store.send(.fetch) {
            $0.viewState = .loading
        }
        await store.receive(\.nowPlayingLoaded) {
            $0.viewState = .ready(
                TVListingsFeature.ViewSnapshot(
                    items: [
                        TVListingsFeature.NowPlayingItem(channel: bbcOne, programme: bbcOneProgramme)
                    ]
                )
            )
        }
    }

}
