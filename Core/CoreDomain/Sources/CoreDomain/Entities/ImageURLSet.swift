//
//  ImageURLSet.swift
//  CoreDomain
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// A set of URLs for an image at different sizes.
///
/// Provides pre-computed URLs for various display contexts, allowing
/// the app to request appropriately sized images for thumbnails, cards,
/// detail views, and full-resolution displays.
///
public struct ImageURLSet: Sendable, Equatable {

    /// The original path of the image.
    public let path: URL

    /// URL for a small thumbnail version of the image.
    public let thumbnail: URL

    /// URL for a medium-sized card version of the image.
    public let card: URL

    /// URL for a larger detail view version of the image.
    public let detail: URL

    /// URL for the full resolution version of the image.
    public let full: URL

    /// Creates a new image URL set.
    ///
    /// - Parameters:
    ///   - path: The original path of the image.
    ///   - thumbnail: URL for the thumbnail version.
    ///   - card: URL for the card version.
    ///   - detail: URL for the detail view version.
    ///   - full: URL for the full resolution version.
    public init(
        path: URL,
        thumbnail: URL,
        card: URL,
        detail: URL,
        full: URL
    ) {
        self.path = path
        self.thumbnail = thumbnail
        self.card = card
        self.detail = detail
        self.full = full
    }

}
