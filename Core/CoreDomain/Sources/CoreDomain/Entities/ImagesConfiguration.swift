//
//  ImagesConfiguration.swift
//  CoreDomain
//
//  Copyright © 2026 Adam Young.
//

import Foundation

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

        enum Still {
            static let thumbnail = 92
            static let card = 185
            static let detail = 300
            static let full = Int.max
        }

    }

    public typealias URLHandler = @Sendable (_ path: URL?, _ idealWidth: Int) -> URL?

    private let posterURLHandler: URLHandler
    private let backdropURLHandler: URLHandler
    private let logoURLHandler: URLHandler
    private let profileURLHandler: URLHandler
    private let stillURLHandler: URLHandler

    public init(
        posterURLHandler: @escaping URLHandler,
        backdropURLHandler: @escaping URLHandler,
        logoURLHandler: @escaping URLHandler,
        profileURLHandler: @escaping URLHandler,
        stillURLHandler: @escaping URLHandler = { _, _ in nil }
    ) {
        self.posterURLHandler = posterURLHandler
        self.backdropURLHandler = backdropURLHandler
        self.logoURLHandler = logoURLHandler
        self.profileURLHandler = profileURLHandler
        self.stillURLHandler = stillURLHandler
    }

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

    public func profileURLSet(for path: URL?) -> ImageURLSet? {
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

    public func stillURLSet(for path: URL?) -> ImageURLSet? {
        guard
            let path,
            let thumbnail = stillURLHandler(path, ImageWidth.Still.thumbnail),
            let card = stillURLHandler(path, ImageWidth.Still.card),
            let detail = stillURLHandler(path, ImageWidth.Still.detail),
            let full = stillURLHandler(path, ImageWidth.Still.full)
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
