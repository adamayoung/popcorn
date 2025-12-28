//
//  TVSeriesPreviewDetails.swift
//  PopcornTrending
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation

///
/// A detailed TV series preview model for presentation in the UI.
///
/// This model extends the basic TV series preview with resolved image URL sets
/// at various resolutions, suitable for direct use in views.
///
public struct TVSeriesPreviewDetails: Identifiable, Equatable, Sendable {

    /// The unique identifier for the TV series.
    public let id: Int

    /// The TV series' name.
    public let name: String

    /// A brief description or summary of the TV series.
    public let overview: String

    /// URL set containing poster images at various resolutions.
    public let posterURLSet: ImageURLSet?

    /// URL set containing backdrop images at various resolutions.
    public let backdropURLSet: ImageURLSet?

    /// URL set containing logo images at various resolutions.
    public let logoURLSet: ImageURLSet?

    ///
    /// Creates a new TV series preview details instance.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the TV series.
    ///   - name: The TV series' name.
    ///   - overview: A brief description or summary.
    ///   - posterURLSet: URL set for poster images. Defaults to `nil`.
    ///   - backdropURLSet: URL set for backdrop images. Defaults to `nil`.
    ///   - logoURLSet: URL set for logo images. Defaults to `nil`.
    ///
    public init(
        id: Int,
        name: String,
        overview: String,
        posterURLSet: ImageURLSet? = nil,
        backdropURLSet: ImageURLSet? = nil,
        logoURLSet: ImageURLSet? = nil
    ) {
        self.id = id
        self.name = name
        self.overview = overview
        self.posterURLSet = posterURLSet
        self.backdropURLSet = backdropURLSet
        self.logoURLSet = logoURLSet
    }

}
