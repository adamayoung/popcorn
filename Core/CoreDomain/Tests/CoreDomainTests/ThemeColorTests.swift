//
//  ThemeColorTests.swift
//  CoreDomain
//
//  Copyright © 2026 Adam Young.
//

@testable import CoreDomain
import Foundation
import Testing

@Suite("ThemeColor")
struct ThemeColorTests {

    @Test("init stores RGB values")
    func initStoresRGBValues() {
        let themeColor = ThemeColor(red: 0.1, green: 0.2, blue: 0.3)

        #expect(themeColor.red == 0.1)
        #expect(themeColor.green == 0.2)
        #expect(themeColor.blue == 0.3)
    }

    @Test("Equatable returns true for same values")
    func equatableReturnsTrueForSameValues() {
        let color1 = ThemeColor(red: 0.5, green: 0.5, blue: 0.5)
        let color2 = ThemeColor(red: 0.5, green: 0.5, blue: 0.5)

        #expect(color1 == color2)
    }

    @Test("Equatable returns false for different values")
    func equatableReturnsFalseForDifferentValues() {
        let color1 = ThemeColor(red: 0.1, green: 0.2, blue: 0.3)
        let color2 = ThemeColor(red: 0.4, green: 0.5, blue: 0.6)

        #expect(color1 != color2)
    }

    @Test("Codable round-trip preserves values")
    func codableRoundTripPreservesValues() throws {
        let original = ThemeColor(red: 0.25, green: 0.75, blue: 0.5)

        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(ThemeColor.self, from: data)

        #expect(decoded == original)
    }

    @Test("boundary values 0.0 and 1.0")
    func boundaryValues() {
        let themeColor = ThemeColor(red: 0.0, green: 1.0, blue: 0.0)

        #expect(themeColor.red == 0.0)
        #expect(themeColor.green == 1.0)
        #expect(themeColor.blue == 0.0)
    }

    @Test("stores negative and greater-than-one values without clamping")
    func storesOutOfRangeValues() {
        let themeColor = ThemeColor(red: -0.5, green: 1.5, blue: 2.0)

        #expect(themeColor.red == -0.5)
        #expect(themeColor.green == 1.5)
        #expect(themeColor.blue == 2.0)
    }

    @Test("Hashable produces same hash for equal values")
    func hashableProducesSameHash() {
        let color1 = ThemeColor(red: 0.1, green: 0.2, blue: 0.3)
        let color2 = ThemeColor(red: 0.1, green: 0.2, blue: 0.3)

        #expect(color1.hashValue == color2.hashValue)
    }

}
