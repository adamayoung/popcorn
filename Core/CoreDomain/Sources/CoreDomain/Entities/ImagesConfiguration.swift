//
//  ImagesConfigurationEntity.swift
//  CoreDomain
//
//  Created by Adam Young on 10/06/2025.
//

import Foundation

public struct ImagesConfiguration: Sendable {

    public typealias URLHandler = @Sendable (URL?, Int) -> URL?

    private let posterURLHandler: URLHandler
    private let backdropURLHandler: URLHandler
    private let logoURLHandler: URLHandler
    private let profileURLHandler: URLHandler

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

    public func posterURLSet(for path: URL?) -> ImageURLSet? {
        guard
            let path,
            let thumbnail = posterURLHandler(path, 185),
            let card = posterURLHandler(path, 342),
            let detail = posterURLHandler(path, 780),
            let full = posterURLHandler(path, .max)
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
            let thumbnail = backdropURLHandler(path, 300),
            let card = backdropURLHandler(path, 300),
            let detail = backdropURLHandler(path, 1280),
            let full = backdropURLHandler(path, .max)
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
            let thumbnail = logoURLHandler(path, 185),
            let card = logoURLHandler(path, 300),
            let detail = logoURLHandler(path, 500),
            let full = logoURLHandler(path, .max)
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

    public func profileURL(for path: URL?) -> ImageURLSet? {
        guard
            let path,
            let thumbnail = profileURLHandler(path, 185),
            let card = profileURLHandler(path, 300),
            let detail = profileURLHandler(path, 500),
            let full = profileURLHandler(path, .max)
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
