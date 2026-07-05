//
//  PersonPreview+Mocks.swift
//  PopcornTrending
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import TrendingDomain

extension PersonPreview {

    static func mock(
        id: Int = 1,
        name: String = "Tom Hanks",
        knownForDepartment: String? = "Acting",
        gender: Gender = .male,
        profilePath: URL? = URL(string: "/profile.jpg"),
        initials: String? = "TH"
    ) -> PersonPreview {
        PersonPreview(
            id: id,
            name: name,
            knownForDepartment: knownForDepartment,
            gender: gender,
            profilePath: profilePath,
            initials: initials
        )
    }

    static var mocks: [PersonPreview] {
        [
            .mock(id: 1, name: "Person One"),
            .mock(id: 2, name: "Person Two"),
            .mock(id: 3, name: "Person Three")
        ]
    }

}
