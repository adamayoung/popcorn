//
//  KnownForItem.swift
//  PopcornPeople
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation

///
/// A movie or TV series a person is known for, ready for presentation.
///
/// Produced by ``FetchPersonKnownForUseCase`` — one of a person's most relevant
/// credits, carrying the image URL sets a carousel cell needs.
///
public struct KnownForItem: Equatable, Sendable {

    ///
    /// The kind of title a known-for item refers to.
    ///
    public enum MediaType: Equatable, Sendable {

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

    /// The title's backdrop image URL set, if available.
    public let backdropURLSet: ImageURLSet?

    /// The title's logo image URL set, if available.
    public let logoURLSet: ImageURLSet?

    ///
    /// Creates a new known-for item.
    ///
    /// - Parameters:
    ///   - id: The identifier of the movie or TV series.
    ///   - mediaType: Whether the item is a movie or a TV series.
    ///   - title: The title of the movie or the name of the TV series.
    ///   - backdropURLSet: The title's backdrop image URL set. Defaults to `nil`.
    ///   - logoURLSet: The title's logo image URL set. Defaults to `nil`.
    ///
    public init(
        id: Int,
        mediaType: MediaType,
        title: String,
        backdropURLSet: ImageURLSet? = nil,
        logoURLSet: ImageURLSet? = nil
    ) {
        self.id = id
        self.mediaType = mediaType
        self.title = title
        self.backdropURLSet = backdropURLSet
        self.logoURLSet = logoURLSet
    }

}
