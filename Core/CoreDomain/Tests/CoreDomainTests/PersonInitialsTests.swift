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
        let result = personInitials(from: "Tom Cruise")

        #expect(result == "TC")
    }

    @Test("three word name returns first and last initials")
    func threeWordName() {
        let result = personInitials(from: "Millie Bobby Brown")

        #expect(result == "MB")
    }

    @Test("single name returns one initial")
    func singleName() {
        let result = personInitials(from: "Zendaya")

        #expect(result == "Z")
    }

    @Test("empty string returns nil")
    func emptyString() {
        let result = personInitials(from: "")

        #expect(result == nil)
    }

    @Test("whitespace only returns nil")
    func whitespaceOnly() {
        let result = personInitials(from: "   ")

        #expect(result == nil)
    }

    @Test("lowercase name returns uppercase initials")
    func lowercaseName() {
        let result = personInitials(from: "tom cruise")

        #expect(result == "TC")
    }

    @Test("extra whitespace is trimmed")
    func extraWhitespace() {
        let result = personInitials(from: "  Tom   Cruise  ")

        #expect(result == "TC")
    }

    @Test("multi-word name returns first and last initials")
    func multiWordName() {
        let result = personInitials(from: "Helena Bonham Carter")

        #expect(result == "HC")
    }

    @Test("suffix name uses last token initial")
    func suffixName() {
        let result = personInitials(from: "Robert Downey Jr.")

        #expect(result == "RJ")
    }

}
