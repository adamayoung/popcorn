//
//  PersonCredit.swift
//  PopcornPeople
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Represents a single credit for a person — a movie or TV series they were
/// involved in, as either a cast or crew member.
///
/// A person can hold more than one credit for the same title (for example both a
/// cast and a crew credit), so ``id`` is **not** unique across a person's credits;
/// identity is the combination of ``mediaType`` and ``id``.
///
public struct PersonCredit: Equatable, Sendable {

    ///
    /// The kind of title a credit refers to.
    ///
    public enum MediaType: Equatable, Sendable {

        /// The credit is for a movie.
        case movie

        /// The credit is for a TV series.
        case tvSeries

    }

    ///
    /// How a person was involved in a title.
    ///
    public enum Role: Equatable, Sendable {

        /// The person appeared in the title's cast.
        case cast

        /// The person worked on the title's crew in the given department.
        case crew(department: String)

    }

    /// The identifier of the credited movie or TV series.
    public let id: Int

    /// Whether the credit is for a movie or a TV series.
    public let mediaType: MediaType

    /// The title of the movie or the name of the TV series.
    public let title: String

    /// URL path to the title's backdrop image, if any.
    public let backdropPath: URL?

    /// URL path to the title's poster image, if any.
    public let posterPath: URL?

    /// The title's popularity score, used to rank a person's most relevant credits.
    public let popularity: Double?

    /// Whether the person was a cast or crew member on the title.
    public let role: Role

    ///
    /// Creates a new person credit.
    ///
    /// - Parameters:
    ///   - id: The identifier of the credited movie or TV series.
    ///   - mediaType: Whether the credit is for a movie or a TV series.
    ///   - title: The title of the movie or the name of the TV series.
    ///   - backdropPath: URL path to the title's backdrop image. Defaults to `nil`.
    ///   - posterPath: URL path to the title's poster image. Defaults to `nil`.
    ///   - popularity: The title's popularity score. Defaults to `nil`.
    ///   - role: Whether the person was a cast or crew member on the title.
    ///
    public init(
        id: Int,
        mediaType: MediaType,
        title: String,
        backdropPath: URL? = nil,
        posterPath: URL? = nil,
        popularity: Double? = nil,
        role: Role
    ) {
        self.id = id
        self.mediaType = mediaType
        self.title = title
        self.backdropPath = backdropPath
        self.posterPath = posterPath
        self.popularity = popularity
        self.role = role
    }

}
