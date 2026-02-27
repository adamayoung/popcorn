//
//  GenderEntityMapperTests.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import Testing
@testable import TVSeriesInfrastructure

@Suite("GenderEntityMapper")
struct GenderEntityMapperTests {

    let mapper = GenderEntityMapper()

    // MARK: - map(Gender) -> Int

    @Test("map unknown gender to 0")
    func mapUnknownGenderToInt() {
        let result = mapper.map(Gender.unknown)

        #expect(result == 0)
    }

    @Test("map female gender to 1")
    func mapFemaleGenderToInt() {
        let result = mapper.map(Gender.female)

        #expect(result == 1)
    }

    @Test("map male gender to 2")
    func mapMaleGenderToInt() {
        let result = mapper.map(Gender.male)

        #expect(result == 2)
    }

    @Test("map other gender to 3")
    func mapOtherGenderToInt() {
        let result = mapper.map(Gender.other)

        #expect(result == 3)
    }

    // MARK: - map(Int) -> Gender

    @Test("map 0 to unknown gender")
    func mapIntToUnknownGender() {
        let result = mapper.map(0)

        #expect(result == .unknown)
    }

    @Test("map 1 to female gender")
    func mapIntToFemaleGender() {
        let result = mapper.map(1)

        #expect(result == .female)
    }

    @Test("map 2 to male gender")
    func mapIntToMaleGender() {
        let result = mapper.map(2)

        #expect(result == .male)
    }

    @Test("map 3 to other gender")
    func mapIntToOtherGender() {
        let result = mapper.map(3)

        #expect(result == .other)
    }

    @Test("map unrecognised code to unknown gender")
    func mapUnrecognisedCodeToUnknownGender() {
        let result = mapper.map(99)

        #expect(result == .unknown)
    }

}
