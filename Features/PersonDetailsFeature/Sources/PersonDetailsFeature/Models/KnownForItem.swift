//
//  KnownForItem.swift
//  PersonDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation

/// A movie or TV series a person is known for, shown in the "Known For" carousel.
public struct KnownForItem: Identifiable, Sendable, Equatable, Hashable {

    /// Whether the item is a movie or a TV series, used to route a tap.
    public enum MediaType: Sendable, Equatable, Hashable {

        /// The item is a movie.
        case movie

        /// The item is a TV series.
        case tvSeries

    }

    /// The identifier of the movie or TV series.
    public let id: Int

    /// Whether the item is a movie or a TV series.
    public let mediaType: MediaType

    /// The title of the movie or the name of the TV series.
    public let title: String

    /// The URL of the item's backdrop image, if any.
    public let backdropURL: URL?

    /// The URL of the item's logo image, if any.
    public let logoURL: URL?

    /// Creates a known-for item.
    ///
    /// - Parameters:
    ///   - id: The identifier of the movie or TV series.
    ///   - mediaType: Whether the item is a movie or a TV series.
    ///   - title: The title of the movie or the name of the TV series.
    ///   - backdropURL: The URL of the item's backdrop image. Defaults to `nil`.
    ///   - logoURL: The URL of the item's logo image. Defaults to `nil`.
    public init(
        id: Int,
        mediaType: MediaType,
        title: String,
        backdropURL: URL? = nil,
        logoURL: URL? = nil
    ) {
        self.id = id
        self.mediaType = mediaType
        self.title = title
        self.backdropURL = backdropURL
        self.logoURL = logoURL
    }

}

extension KnownForItem {

    static var mocks: [KnownForItem] {
        [
            KnownForItem(
                id: 111,
                mediaType: .movie,
                title: "The Devil Wears Prada",
                backdropURL: URL(string: "https://image.tmdb.org/t/p/w1280/mock-backdrop-1.jpg"),
                logoURL: URL(string: "https://image.tmdb.org/t/p/w500/mock-logo-1.png")
            ),
            KnownForItem(
                id: 222,
                mediaType: .tvSeries,
                title: "Fortitude",
                backdropURL: URL(string: "https://image.tmdb.org/t/p/w1280/mock-backdrop-2.jpg"),
                logoURL: URL(string: "https://image.tmdb.org/t/p/w500/mock-logo-2.png")
            ),
            KnownForItem(
                id: 333,
                mediaType: .movie,
                title: "The Hunger Games",
                backdropURL: URL(string: "https://image.tmdb.org/t/p/w1280/mock-backdrop-3.jpg"),
                logoURL: URL(string: "https://image.tmdb.org/t/p/w500/mock-logo-3.png")
            )
        ]
    }

}
