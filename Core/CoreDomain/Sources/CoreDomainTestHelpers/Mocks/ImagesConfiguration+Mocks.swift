//
//  ImagesConfiguration+Mocks.swift
//  CoreDomain
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation

public extension ImagesConfiguration {

    static func mock(
        posterURLHandler: @escaping URLHandler = Self.posterURLHandlerMock,
        backdropURLHandler: @escaping URLHandler = Self.backdropURLHandlerMock,
        logoURLHandler: @escaping URLHandler = Self.logoURLHandlerMock,
        profileURLHandler: @escaping URLHandler = Self.profileURLHandlerMock,
        stillURLHandler: @escaping URLHandler = Self.stillURLHandlerMock
    ) -> ImagesConfiguration {
        ImagesConfiguration(
            posterURLHandler: posterURLHandler,
            backdropURLHandler: backdropURLHandler,
            logoURLHandler: logoURLHandler,
            profileURLHandler: profileURLHandler,
            stillURLHandler: stillURLHandler
        )
    }

    static func posterURLHandlerMock(path: URL?, idealWidth: Int) -> URL? {
        guard let path = path?.absoluteString else {
            return nil
        }

        return URL(string: "https://image.popcorn.dev/poster/\(idealWidth)\(path)")
    }

    static func backdropURLHandlerMock(path: URL?, idealWidth: Int) -> URL? {
        guard let path = path?.absoluteString else {
            return nil
        }

        return URL(string: "https://image.popcorn.dev/backdrop/\(idealWidth)\(path)")
    }

    static func logoURLHandlerMock(path: URL?, idealWidth: Int) -> URL? {
        guard let path = path?.absoluteString else {
            return nil
        }

        return URL(string: "https://image.popcorn.dev/logo/\(idealWidth)\(path)")
    }

    static func profileURLHandlerMock(path: URL?, idealWidth: Int) -> URL? {
        guard let path = path?.absoluteString else {
            return nil
        }

        return URL(string: "https://image.popcorn.dev/profile/\(idealWidth)\(path)")
    }

    static func stillURLHandlerMock(path: URL?, idealWidth: Int) -> URL? {
        guard let path = path?.absoluteString else {
            return nil
        }

        return URL(string: "https://image.popcorn.dev/still/\(idealWidth)\(path)")
    }
}
