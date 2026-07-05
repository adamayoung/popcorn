//
//  PersonPreviewDetailsMapperTests.swift
//  PopcornTrending
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import CoreDomainTestHelpers
import Foundation
import Testing
@testable import TrendingApplication
import TrendingDomain

@Suite("PersonPreviewDetailsMapper")
struct PersonPreviewDetailsMapperTests {

    let mapper = PersonPreviewDetailsMapper()
    let imagesConfiguration = ImagesConfiguration.mock()

    @Test("maps core properties from person preview")
    func mapsCoreProperties() {
        let personPreview = PersonPreview.mock(
            id: 31,
            name: "Tom Hanks",
            knownForDepartment: "Acting",
            gender: .male,
            initials: "TH"
        )

        let result = mapper.map(personPreview, imagesConfiguration: imagesConfiguration)

        #expect(result.id == 31)
        #expect(result.name == "Tom Hanks")
        #expect(result.knownForDepartment == "Acting")
        #expect(result.gender == .male)
        #expect(result.initials == "TH")
    }

    @Test("currently sizes the profile with the poster handler (known quirk)")
    func mapsProfileURLSetUsingPosterHandler() {
        // Characterization of current (wrong) behaviour: the mapper sizes the
        // profile via `posterURLSet(for:)` instead of `profileURLSet(for:)`, so
        // profiles are fetched at poster width buckets. Do NOT re-point this
        // assertion to `profileURLSet(for:)` without fixing the production mapper.
        let personPreview = PersonPreview.mock(profilePath: URL(string: "/profile.jpg"))

        let result = mapper.map(personPreview, imagesConfiguration: imagesConfiguration)

        #expect(result.profileURLSet == imagesConfiguration.posterURLSet(for: personPreview.profilePath))
    }

    @Test("returns nil profile URL set when profile path is nil")
    func returnsNilProfileURLSetWhenProfilePathIsNil() {
        let personPreview = PersonPreview.mock(profilePath: nil)

        let result = mapper.map(personPreview, imagesConfiguration: imagesConfiguration)

        #expect(result.profileURLSet == nil)
    }

    @Test("maps nil knownForDepartment and initials")
    func mapsNilKnownForDepartmentAndInitials() {
        let personPreview = PersonPreview.mock(knownForDepartment: nil, initials: nil)

        let result = mapper.map(personPreview, imagesConfiguration: imagesConfiguration)

        #expect(result.knownForDepartment == nil)
        #expect(result.initials == nil)
    }

}
