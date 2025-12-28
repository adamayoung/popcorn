//
//  TVSeriesPreviewDetails.swift
//  PopcornSearch
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation

///
/// Represents detailed TV series preview information for UI display.
///
/// This model extends the basic TV series preview with fully resolved image URL sets
/// at multiple resolutions, suitable for displaying TV series cards and details in the UI.
///
public struct TVSeriesPreviewDetails: Identifiable, Equatable, Sendable {

    /// The unique identifier for the TV series.
    public let id: Int

    /// The TV series' name.
    public let name: String

    /// A brief description or plot summary of the TV series.
    public let overview: String

    /// URL set for the TV series' poster image at various resolutions.
    public let posterURLSet: ImageURLSet?

    /// URL set for the TV series' backdrop image at various resolutions.
    public let backdropURLSet: ImageURLSet?

    /// URL set for the TV series' logo image at various resolutions.
    public let logoURLSet: ImageURLSet?

    ///
    /// Creates a new TV series preview details instance.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the TV series.
    ///   - name: The TV series' name.
    ///   - overview: A brief description or plot summary.
    ///   - posterURLSet: URL set for the poster image. Defaults to `nil`.
    ///   - backdropURLSet: URL set for the backdrop image. Defaults to `nil`.
    ///   - logoURLSet: URL set for the logo image. Defaults to `nil`.
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
