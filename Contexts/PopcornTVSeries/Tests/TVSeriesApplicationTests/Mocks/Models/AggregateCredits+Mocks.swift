//
//  AggregateCredits+Mocks.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesDomain

extension AggregateCredits {

    static func mock(
        id: Int = 66732,
        cast: [AggregateCastMember] = AggregateCastMember.mocks,
        crew: [AggregateCrewMember] = AggregateCrewMember.mocks
    ) -> AggregateCredits {
        AggregateCredits(
            id: id,
            cast: cast,
            crew: crew
        )
    }

}

extension AggregateCastMember {

    static var mocks: [AggregateCastMember] {
        [
            AggregateCastMember(
                id: 17419,
                name: "Millie Bobby Brown",
                profilePath: URL(string: "/3WsZbEbqMkFb5WCkNKBqYGlOxoA.jpg"),
                gender: .female,
                roles: [CastRole(creditID: "cr-1", character: "Eleven", episodeCount: 34)],
                totalEpisodeCount: 34
            ),
            AggregateCastMember(
                id: 37153,
                name: "David Harbour",
                profilePath: URL(string: "/chPekukMF5SNnW6b22NbYPqAR3Y.jpg"),
                gender: .male,
                roles: [CastRole(creditID: "cr-2", character: "Jim Hopper", episodeCount: 33)],
                totalEpisodeCount: 33
            )
        ]
    }

}

extension AggregateCrewMember {

    static var mocks: [AggregateCrewMember] {
        [
            AggregateCrewMember(
                id: 1_222_585,
                name: "Matt Duffer",
                profilePath: URL(string: "/kXO5CnSxOmB1lFEBrfNUMi3cRzJ.jpg"),
                gender: .male,
                department: "Production",
                jobs: [CrewJob(creditID: "cj-1", job: "Creator", episodeCount: 34)],
                totalEpisodeCount: 34
            )
        ]
    }

}
