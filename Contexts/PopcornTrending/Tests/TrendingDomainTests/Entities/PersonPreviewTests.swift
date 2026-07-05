//
//  PersonPreviewTests.swift
//  PopcornTrending
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import Testing
@testable import TrendingDomain

@Suite("PersonPreview")
struct PersonPreviewTests {

    @Test("init assigns all properties")
    func initAssignsAllProperties() {
        let profilePath = URL(string: "/profile.jpg")

        let personPreview = PersonPreview(
            id: 31,
            name: "Tom Hanks",
            knownForDepartment: "Acting",
            gender: .male,
            profilePath: profilePath,
            initials: "TH"
        )

        #expect(personPreview.id == 31)
        #expect(personPreview.name == "Tom Hanks")
        #expect(personPreview.knownForDepartment == "Acting")
        #expect(personPreview.gender == .male)
        #expect(personPreview.profilePath == profilePath)
        #expect(personPreview.initials == "TH")
    }

    @Test("optional properties default to nil when omitted")
    func optionalPropertiesDefaultToNilWhenOmitted() {
        let personPreview = PersonPreview(id: 1, name: "Test Person", gender: .unknown)

        #expect(personPreview.knownForDepartment == nil)
        #expect(personPreview.profilePath == nil)
        #expect(personPreview.initials == nil)
    }

    @Test("instances with equal properties are equal")
    func instancesWithEqualPropertiesAreEqual() {
        let first = PersonPreview(id: 1, name: "Test Person", gender: .male)
        let second = PersonPreview(id: 1, name: "Test Person", gender: .male)

        #expect(first == second)
    }

    @Test("instances with different gender are not equal")
    func instancesWithDifferentGenderAreNotEqual() {
        let first = PersonPreview(id: 1, name: "Test Person", gender: .male)
        let second = PersonPreview(id: 1, name: "Test Person", gender: .female)

        #expect(first != second)
    }

}
