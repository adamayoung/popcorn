//
//  ImagesConfiguration+Mocks.swift
//  CoreDomain
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation

public extension ImagesConfiguration {

    ///
    /// Creates a mock images configuration for testing purposes.
    ///
    /// - Parameters:
    ///   - posterURLHandler: The handler for building poster URLs. Defaults to
    /// ``posterURLHandlerMock(path:idealWidth:)``.
    ///   - backdropURLHandler: The handler for building backdrop URLs. Defaults to
    /// ``backdropURLHandlerMock(path:idealWidth:)``.
    ///   - logoURLHandler: The handler for building logo URLs. Defaults to ``logoURLHandlerMock(path:idealWidth:)``.
    ///   - profileURLHandler: The handler for building profile URLs. Defaults to
    /// ``profileURLHandlerMock(path:idealWidth:)``.
    ///
    /// - Returns: A mock ``ImagesConfiguration`` instance.
    ///
    static func mock(
        posterURLHandler: @escaping URLHandler = Self.posterURLHandlerMock,
        backdropURLHandler: @escaping URLHandler = Self.backdropURLHandlerMock,
        logoURLHandler: @escaping URLHandler = Self.logoURLHandlerMock,
        profileURLHandler: @escaping URLHandler = Self.profileURLHandlerMock
    ) -> ImagesConfiguration {
        ImagesConfiguration(
            posterURLHandler: posterURLHandler,
            backdropURLHandler: backdropURLHandler,
            logoURLHandler: logoURLHandler,
            profileURLHandler: profileURLHandler
        )
    }

    ///
    /// A mock poster URL handler for testing.
    ///
    /// Generates URLs in the format `https://image.popcorn.dev/poster/{width}{path}`.
    ///
    /// - Parameters:
    ///   - path: The image path.
    ///   - idealWidth: The ideal width for the image.
    ///
    /// - Returns: A mock URL for the poster image, or `nil` if the path is `nil`.
    ///
    static func posterURLHandlerMock(path: URL?, idealWidth: Int) -> URL? {
        guard let path = path?.absoluteString else {
            return nil
        }

        return URL(string: "https://image.popcorn.dev/poster/\(idealWidth)\(path)")
    }

    ///
    /// A mock backdrop URL handler for testing.
    ///
    /// Generates URLs in the format `https://image.popcorn.dev/backdrop/{width}{path}`.
    ///
    /// - Parameters:
    ///   - path: The image path.
    ///   - idealWidth: The ideal width for the image.
    ///
    /// - Returns: A mock URL for the backdrop image, or `nil` if the path is `nil`.
    ///
    static func backdropURLHandlerMock(path: URL?, idealWidth: Int) -> URL? {
        guard let path = path?.absoluteString else {
            return nil
        }

        return URL(string: "https://image.popcorn.dev/backdrop/\(idealWidth)\(path)")
    }

    ///
    /// A mock logo URL handler for testing.
    ///
    /// Generates URLs in the format `https://image.popcorn.dev/logo/{width}{path}`.
    ///
    /// - Parameters:
    ///   - path: The image path.
    ///   - idealWidth: The ideal width for the image.
    ///
    /// - Returns: A mock URL for the logo image, or `nil` if the path is `nil`.
    ///
    static func logoURLHandlerMock(path: URL?, idealWidth: Int) -> URL? {
        guard let path = path?.absoluteString else {
            return nil
        }

        return URL(string: "https://image.popcorn.dev/logo/\(idealWidth)\(path)")
    }

    ///
    /// A mock profile URL handler for testing.
    ///
    /// Generates URLs in the format `https://image.popcorn.dev/profile/{width}{path}`.
    ///
    /// - Parameters:
    ///   - path: The image path.
    ///   - idealWidth: The ideal width for the image.
    ///
    /// - Returns: A mock URL for the profile image, or `nil` if the path is `nil`.
    ///
    static func profileURLHandlerMock(path: URL?, idealWidth: Int) -> URL? {
        guard let path = path?.absoluteString else {
            return nil
        }

        return URL(string: "https://image.popcorn.dev/profile/\(idealWidth)\(path)")
    }
}
