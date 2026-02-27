//
//  PersonInitialsTests.swift
//  CoreDomain
//
//  Copyright © 2026 Adam Young.
//

@testable import CoreDomain
import Testing

@Suite("PersonInitials")
struct PersonInitialsTests {

    @Test("two word name returns both initials")
    func twoWordName() {
        let result = PersonInitials.resolve(from: "Tom Cruise")

        #expect(result == "TC")
    }

    @Test("three word name returns first and last initials")
    func threeWordName() {
        let result = PersonInitials.resolve(from: "Millie Bobby Brown")

        #expect(result == "MB")
    }

    @Test("single name returns one initial")
    func singleName() {
        let result = PersonInitials.resolve(from: "Zendaya")

        #expect(result == "Z")
    }

    @Test("empty string returns nil")
    func emptyString() {
        let result = PersonInitials.resolve(from: "")

        #expect(result == nil)
    }

    @Test("whitespace only returns nil")
    func whitespaceOnly() {
        let result = PersonInitials.resolve(from: "   ")

        #expect(result == nil)
    }

    @Test("lowercase name returns uppercase initials")
    func lowercaseName() {
        let result = PersonInitials.resolve(from: "tom cruise")

        #expect(result == "TC")
    }

    @Test("extra whitespace is trimmed")
    func extraWhitespace() {
        let result = PersonInitials.resolve(from: "  Tom   Cruise  ")

        #expect(result == "TC")
    }

    @Test("multi-word name returns first and last initials")
    func multiWordName() {
        let result = PersonInitials.resolve(from: "Helena Bonham Carter")

        #expect(result == "HC")
    }

    @Test("name with Jr. suffix ignores suffix")
    func suffixJr() {
        let result = PersonInitials.resolve(from: "Robert Downey Jr.")

        #expect(result == "RD")
    }

    @Test("name with Sr. suffix ignores suffix")
    func suffixSr() {
        let result = PersonInitials.resolve(from: "Martin Luther King Sr.")

        #expect(result == "MK")
    }

    @Test("name with numeral suffix ignores suffix")
    func suffixNumeral() {
        let result = PersonInitials.resolve(from: "Robert Downey III")

        #expect(result == "RD")
    }

    @Test("first name with suffix returns single initial")
    func firstNameWithSuffix() {
        let result = PersonInitials.resolve(from: "John Jr.")

        #expect(result == "J")
    }

    @Test("suffix-only input returns first character")
    func suffixOnly() {
        let result = PersonInitials.resolve(from: "Jr.")

        #expect(result == "J")
    }

    @Test("name with Esq suffix without period ignores suffix")
    func suffixEsqNoPeriod() {
        let result = PersonInitials.resolve(from: "John Smith Esq")

        #expect(result == "JS")
    }

    @Test("name with non-breaking space splits correctly")
    func nonBreakingSpace() {
        let result = PersonInitials.resolve(from: "Tom\u{00a0}Cruise")

        #expect(result == "TC")
    }

    @Test("leading suffix uses first meaningful word")
    func leadingSuffix() {
        let result = PersonInitials.resolve(from: "II John Smith")

        #expect(result == "JS")
    }

}
