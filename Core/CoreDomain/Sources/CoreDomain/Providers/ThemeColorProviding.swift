//
//  ThemeColorProviding.swift
//  CoreDomain
//
//  Copyright © 2026 Adam Young.
//

import Foundation

/// Provides theme colors extracted from poster thumbnail images.
///
/// Implementations download the poster thumbnail, extract the average color, and cache the result.
public protocol ThemeColorProviding: Sendable {

    /// Extracts the average color from a poster thumbnail image.
    ///
    /// - Parameter posterThumbnailURL: The URL of the poster thumbnail image.
    ///
    /// - Returns: The extracted theme color, or `nil` if extraction fails.
    func themeColor(for posterThumbnailURL: URL) async -> ThemeColor?

}
