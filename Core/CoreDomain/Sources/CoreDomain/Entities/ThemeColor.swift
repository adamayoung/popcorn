//
//  ThemeColor.swift
//  CoreDomain
//
//  Copyright © 2026 Adam Young.
//

import Foundation

/// A color extracted from a poster image, represented as RGB components.
///
/// Values are stored as-is without clamping. Each component is typically in the range `0.0...1.0`.
public struct ThemeColor: Sendable, Equatable, Codable, Hashable {

    /// The red component of the color.
    public let red: Double

    /// The green component of the color.
    public let green: Double

    /// The blue component of the color.
    public let blue: Double

    /// Creates a theme color with the specified RGB components.
    ///
    /// - Parameters:
    ///   - red: The red component.
    ///   - green: The green component.
    ///   - blue: The blue component.
    public init(red: Double, green: Double, blue: Double) {
        self.red = red
        self.green = green
        self.blue = blue
    }

}
