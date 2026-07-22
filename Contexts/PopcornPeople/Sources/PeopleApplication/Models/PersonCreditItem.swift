//
//  PersonCreditItem.swift
//  PopcornPeople
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation

///
/// A movie or TV series a person is credited on, ready for presentation.
///
/// Produced by ``FetchPersonCreditsUseCase`` — one row of a person's full
/// credits list. A person's multiple credits on the same title (for example
/// both acting and producing) are merged into a single item, with each part
/// they played collected into ``parts``.
///
public struct PersonCreditItem: Equatable, Sendable {

    ///
    /// The kind of title a credit item refers to.
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

    /// The parts the person played on the title — cast characters first, then
    /// crew jobs. Empty when TMDb reports no part for any of the credits.
    public let parts: [String]

    /// The movie's release date or the TV series' first air date, if known.
    public let date: Date?

    /// The title's poster image URL set, if available.
    public let posterURLSet: ImageURLSet?

    ///
    /// Creates a new person credit item.
    ///
    /// - Parameters:
    ///   - id: The identifier of the movie or TV series.
    ///   - mediaType: Whether the item is a movie or a TV series.
    ///   - title: The title of the movie or the name of the TV series.
    ///   - parts: The parts the person played on the title. Defaults to empty.
    ///   - date: The movie's release date or the TV series' first air date. Defaults to `nil`.
    ///   - posterURLSet: The title's poster image URL set. Defaults to `nil`.
    ///
    public init(
        id: Int,
        mediaType: MediaType,
        title: String,
        parts: [String] = [],
        date: Date? = nil,
        posterURLSet: ImageURLSet? = nil
    ) {
        self.id = id
        self.mediaType = mediaType
        self.title = title
        self.parts = parts
        self.date = date
        self.posterURLSet = posterURLSet
    }

}
