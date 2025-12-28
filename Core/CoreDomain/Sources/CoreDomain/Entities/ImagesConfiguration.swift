//
//  ImagesConfiguration.swift
//  CoreDomain
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Configuration for building image URLs at various sizes.
///
/// Provides handlers for generating properly sized URLs for different
/// image types including posters, backdrops, logos, and profile images.
/// Each handler takes a path and ideal width and returns the appropriate URL.
///
public struct ImagesConfiguration: Sendable {

    private enum ImageWidth {
        enum Poster {
            static let thumbnail = 185
            static let card = 342
            static let detail = 780
            static let full = Int.max
        }

        enum Backdrop {
            static let thumbnail = 300
            static let card = 300
            static let detail = 1280
            static let full = Int.max
        }

        enum Logo {
            static let thumbnail = 185
            static let card = 300
            static let detail = 500
            static let full = Int.max
        }

        enum Profile {
            static let thumbnail = 185
            static let card = 300
            static let detail = 500
            static let full = Int.max
        }

    }

    /// A closure that builds a URL for an image path at a specified width.
    public typealias URLHandler = @Sendable (_ path: URL?, _ idealWidth: Int) -> URL?

    private let posterURLHandler: URLHandler
    private let backdropURLHandler: URLHandler
    private let logoURLHandler: URLHandler
    private let profileURLHandler: URLHandler

    /// Creates a new images configuration.
    ///
    /// - Parameters:
    ///   - posterURLHandler: Handler for building poster image URLs.
    ///   - backdropURLHandler: Handler for building backdrop image URLs.
    ///   - logoURLHandler: Handler for building logo image URLs.
    ///   - profileURLHandler: Handler for building profile image URLs.
    public init(
        posterURLHandler: @escaping URLHandler,
        backdropURLHandler: @escaping URLHandler,
        logoURLHandler: @escaping URLHandler,
        profileURLHandler: @escaping URLHandler
    ) {
        self.posterURLHandler = posterURLHandler
        self.backdropURLHandler = backdropURLHandler
        self.logoURLHandler = logoURLHandler
        self.profileURLHandler = profileURLHandler
    }

    /// Builds a URL set for a poster image.
    ///
    /// - Parameter path: The image path to build URLs for.
    /// - Returns: An ``ImageURLSet`` containing URLs at various sizes, or `nil` if the path is invalid.
    public func posterURLSet(for path: URL?) -> ImageURLSet? {
        guard
            let path,
            let thumbnail = posterURLHandler(path, ImageWidth.Poster.thumbnail),
            let card = posterURLHandler(path, ImageWidth.Poster.card),
            let detail = posterURLHandler(path, ImageWidth.Poster.detail),
            let full = posterURLHandler(path, ImageWidth.Poster.full)
        else {
            return nil
        }

        return ImageURLSet(
            path: path,
            thumbnail: thumbnail,
            card: card,
            detail: detail,
            full: full
        )
    }

    /// Builds a URL set for a backdrop image.
    ///
    /// - Parameter path: The image path to build URLs for.
    /// - Returns: An ``ImageURLSet`` containing URLs at various sizes, or `nil` if the path is invalid.
    public func backdropURLSet(for path: URL?) -> ImageURLSet? {
        guard
            let path,
            let thumbnail = backdropURLHandler(path, ImageWidth.Backdrop.thumbnail),
            let card = backdropURLHandler(path, ImageWidth.Backdrop.card),
            let detail = backdropURLHandler(path, ImageWidth.Backdrop.detail),
            let full = backdropURLHandler(path, ImageWidth.Backdrop.full)
        else {
            return nil
        }

        return ImageURLSet(
            path: path,
            thumbnail: thumbnail,
            card: card,
            detail: detail,
            full: full
        )
    }

    /// Builds a URL set for a logo image.
    ///
    /// - Parameter path: The image path to build URLs for.
    /// - Returns: An ``ImageURLSet`` containing URLs at various sizes, or `nil` if the path is invalid.
    public func logoURLSet(for path: URL?) -> ImageURLSet? {
        guard
            let path,
            let thumbnail = logoURLHandler(path, ImageWidth.Logo.thumbnail),
            let card = logoURLHandler(path, ImageWidth.Logo.card),
            let detail = logoURLHandler(path, ImageWidth.Logo.detail),
            let full = logoURLHandler(path, ImageWidth.Logo.full)
        else {
            return nil
        }

        return ImageURLSet(
            path: path,
            thumbnail: thumbnail,
            card: card,
            detail: detail,
            full: full
        )
    }

    /// Builds a URL set for a profile image.
    ///
    /// - Parameter path: The image path to build URLs for.
    /// - Returns: An ``ImageURLSet`` containing URLs at various sizes, or `nil` if the path is invalid.
    public func profileURL(for path: URL?) -> ImageURLSet? {
        guard
            let path,
            let thumbnail = profileURLHandler(path, ImageWidth.Profile.thumbnail),
            let card = profileURLHandler(path, ImageWidth.Profile.card),
            let detail = profileURLHandler(path, ImageWidth.Profile.detail),
            let full = profileURLHandler(path, ImageWidth.Profile.full)
        else {
            return nil
        }

        return ImageURLSet(
            path: path,
            thumbnail: thumbnail,
            card: card,
            detail: detail,
            full: full
        )
    }

}
