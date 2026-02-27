//
//  ImagesConfigurationTests.swift
//  CoreDomain
//
//  Copyright © 2026 Adam Young.
//

@testable import CoreDomain
import Foundation
import Testing

@Suite("ImagesConfiguration")
struct ImagesConfigurationTests {

    @Test("stillURLSet returns ImageURLSet when path is valid")
    func stillURLSetReturnsImageURLSetWhenPathIsValid() throws {
        let path = try #require(URL(string: "/still123.jpg"))
        let imagesConfiguration = ImagesConfiguration(
            posterURLHandler: { _, _ in nil },
            backdropURLHandler: { _, _ in nil },
            logoURLHandler: { _, _ in nil },
            profileURLHandler: { _, _ in nil },
            stillURLHandler: { path, idealWidth in
                guard let path else {
                    return nil
                }
                return URL(string: "https://image.tmdb.org/t/p/w\(idealWidth)\(path.absoluteString)")
            }
        )

        let result = imagesConfiguration.stillURLSet(for: path)

        #expect(result != nil)
        #expect(result?.path == path)
        #expect(result?.thumbnail.absoluteString == "https://image.tmdb.org/t/p/w92/still123.jpg")
        #expect(result?.card.absoluteString == "https://image.tmdb.org/t/p/w185/still123.jpg")
        #expect(result?.detail.absoluteString == "https://image.tmdb.org/t/p/w300/still123.jpg")
        #expect(result?.full.absoluteString.contains("/still123.jpg") == true)
    }

    @Test("stillURLSet returns nil when path is nil")
    func stillURLSetReturnsNilWhenPathIsNil() {
        let imagesConfiguration = ImagesConfiguration(
            posterURLHandler: { _, _ in nil },
            backdropURLHandler: { _, _ in nil },
            logoURLHandler: { _, _ in nil },
            profileURLHandler: { _, _ in nil },
            stillURLHandler: { path, idealWidth in
                guard let path else {
                    return nil
                }
                return URL(string: "https://image.tmdb.org/t/p/w\(idealWidth)\(path.absoluteString)")
            }
        )

        let result = imagesConfiguration.stillURLSet(for: nil)

        #expect(result == nil)
    }

    @Test("stillURLHandler defaults to nil handler when not provided")
    func stillURLHandlerDefaultsToNilHandler() throws {
        let path = try #require(URL(string: "/still123.jpg"))
        let imagesConfiguration = ImagesConfiguration(
            posterURLHandler: { _, _ in nil },
            backdropURLHandler: { _, _ in nil },
            logoURLHandler: { _, _ in nil },
            profileURLHandler: { _, _ in nil }
        )

        let result = imagesConfiguration.stillURLSet(for: path)

        #expect(result == nil)
    }

}
