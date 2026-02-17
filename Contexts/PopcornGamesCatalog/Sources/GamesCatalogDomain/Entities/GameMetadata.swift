//
//  GameMetadata.swift
//  PopcornGamesCatalog
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Represents metadata for a game in the games catalog.
///
/// This entity provides the essential information needed to display and describe games
/// in the catalog interface, including visual elements like icons and color tags. It serves
/// as a lightweight representation of games for browsing, before users navigate to the
/// full game experience.
///
public struct GameMetadata: Identifiable, Sendable {

    /// The unique identifier for the game.
    public let id: Int

    /// The display name of the game.
    public let name: String

    /// A brief description of the game's concept and gameplay.
    public let description: String

    /// The SF Symbols system icon name used to represent the game.
    public let iconSystemName: String

    /// The color tag used for visual categorization in the catalog.
    public let color: GameColorTag

    ///
    /// Creates new game metadata.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the game.
    ///   - name: The display name of the game.
    ///   - description: A brief description of the game.
    ///   - iconSystemName: The SF Symbols icon name for the game.
    ///   - color: The color tag for visual categorization.
    ///
    public init(
        id: Int,
        name: String,
        description: String,
        iconSystemName: String,
        color: GameColorTag
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.iconSystemName = iconSystemName
        self.color = color
    }

}
