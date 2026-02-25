//
//  Credits+Mocks.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesDomain

extension Credits {

    static func mock(
        id: Int = 1,
        cast: [CastMember] = CastMember.mocks,
        crew: [CrewMember] = CrewMember.mocks
    ) -> Credits {
        Credits(
            id: id,
            cast: cast,
            crew: crew
        )
    }

}
