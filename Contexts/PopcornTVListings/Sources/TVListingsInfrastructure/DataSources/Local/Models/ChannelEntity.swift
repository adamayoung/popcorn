//
//  ChannelEntity.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SwiftData

@Model
final class ChannelEntity: Equatable {

    @Attribute(.unique) var channelID: String
    var name: String
    // Stored as the `ChannelType` raw value ("tv"/"radio"); mapped back in `ChannelEntityMapper`.
    var type: String
    var isHD: Bool
    var logoURL: URL?

    init(
        channelID: String,
        name: String,
        type: String,
        isHD: Bool,
        logoURL: URL?
    ) {
        self.channelID = channelID
        self.name = name
        self.type = type
        self.isHD = isHD
        self.logoURL = logoURL
    }

}
