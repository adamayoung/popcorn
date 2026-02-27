//
//  GenderMapperTests.swift
//  PopcornTVSeriesAdapters
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
@testable import PopcornTVSeriesAdapters
import Testing
import TMDb

@Suite("GenderMapper Tests")
struct GenderMapperTests {

    private let mapper = GenderMapper()

    @Test("map converts unknown gender")
    func mapConvertsUnknownGender() {
        let result = mapper.map(.unknown)

        #expect(result == .unknown)
    }

    @Test("map converts female gender")
    func mapConvertsFemaleGender() {
        let result = mapper.map(.female)

        #expect(result == .female)
    }

    @Test("map converts male gender")
    func mapConvertsMaleGender() {
        let result = mapper.map(.male)

        #expect(result == .male)
    }

    @Test("map converts other gender")
    func mapConvertsOtherGender() {
        let result = mapper.map(.other)

        #expect(result == .other)
    }

    @Test("compactMap returns nil for nil input")
    func compactMapReturnsNilForNilInput() {
        let result = mapper.compactMap(nil)

        #expect(result == nil)
    }

    @Test("compactMap returns mapped value for non-nil input")
    func compactMapReturnsMappedValueForNonNilInput() {
        let result = mapper.compactMap(.female)

        #expect(result == .female)
    }

    @Test("compactMap maps all gender values correctly")
    func compactMapMapsAllGenderValuesCorrectly() {
        #expect(mapper.compactMap(.unknown) == .unknown)
        #expect(mapper.compactMap(.female) == .female)
        #expect(mapper.compactMap(.male) == .male)
        #expect(mapper.compactMap(.other) == .other)
    }

}
