//
//  CreditItem.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

/// A movie or TV series credit shown as one row of the person credits list.
public struct CreditItem: Identifiable, Equatable, Sendable {

    /// The kind of title a credit refers to.
    public enum MediaType: Equatable, Sendable {

        /// The credit is for a movie.
        case movie

        /// The credit is for a TV series.
        case tvSeries

    }

    /// The TMDb identifier of the movie or TV series.
    ///
    /// Not unique across a person's credits on its own — a movie and a TV
    /// series can share a TMDb id — so list identity comes from ``id``.
    public let mediaID: Int

    /// Whether the credit is for a movie or a TV series.
    public let mediaType: MediaType

    /// The title of the movie or the name of the TV series.
    public let title: String

    /// The parts the person played, pre-joined for display
    /// (for example "Tony Stark · Executive Producer"), or `nil` when unknown.
    public let partsText: String?

    /// The movie's release date or the TV series' first air date, if known.
    public let date: Date?

    /// URL of the title's poster image, if available.
    public let posterURL: URL?

    /// A list-stable identity combining the media type and TMDb id.
    public var id: String {
        switch mediaType {
        case .movie: "movie-\(mediaID)"
        case .tvSeries: "tv-\(mediaID)"
        }
    }

    ///
    /// Creates a new credit item.
    ///
    /// - Parameters:
    ///   - mediaID: The TMDb identifier of the movie or TV series.
    ///   - mediaType: Whether the credit is for a movie or a TV series.
    ///   - title: The title of the movie or the name of the TV series.
    ///   - partsText: The parts the person played, pre-joined for display. Defaults to `nil`.
    ///   - date: The movie's release date or the TV series' first air date. Defaults to `nil`.
    ///   - posterURL: URL of the title's poster image. Defaults to `nil`.
    ///
    public init(
        mediaID: Int,
        mediaType: MediaType,
        title: String,
        partsText: String? = nil,
        date: Date? = nil,
        posterURL: URL? = nil
    ) {
        self.mediaID = mediaID
        self.mediaType = mediaType
        self.title = title
        self.partsText = partsText
        self.date = date
        self.posterURL = posterURL
    }

}

#if DEBUG
    extension CreditItem {

        /// A single mock credit item for tests.
        static func mock(
            mediaID: Int = 550,
            mediaType: MediaType = .movie,
            title: String = "Fight Club",
            partsText: String? = "The Narrator",
            date: Date? = Date(timeIntervalSince1970: 908_236_800),
            posterURL: URL? = nil
        ) -> CreditItem {
            CreditItem(
                mediaID: mediaID,
                mediaType: mediaType,
                title: title,
                partsText: partsText,
                date: date,
                posterURL: posterURL
            )
        }

        /// Mock credit items for previews and snapshot tests.
        static var mocks: [CreditItem] {
            [
                CreditItem(
                    mediaID: 986_056,
                    mediaType: .movie,
                    title: "Thunderbolts*",
                    partsText: "Bucky Barnes",
                    date: nil
                ),
                CreditItem(
                    mediaID: 1396,
                    mediaType: .tvSeries,
                    title: "Breaking Bad",
                    partsText: "Walter White",
                    date: Date(timeIntervalSince1970: 1_200_873_600)
                ),
                CreditItem(
                    mediaID: 27205,
                    mediaType: .movie,
                    title: "Inception",
                    partsText: "Cobb · Executive Producer",
                    date: Date(timeIntervalSince1970: 1_279_238_400)
                ),
                CreditItem(
                    mediaID: 550,
                    mediaType: .movie,
                    title: "Fight Club",
                    partsText: nil,
                    date: Date(timeIntervalSince1970: 908_236_800)
                )
            ]
        }

    }
#endif
