//
//  TVChannelEntity.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SwiftData

@Model
final class TVChannelEntity: Equatable {

    @Attribute(.unique) var channelID: String
    var name: String
    var isHD: Bool
    var logoURL: URL?

    init(
        channelID: String,
        name: String,
        isHD: Bool,
        logoURL: URL?
    ) {
        self.channelID = channelID
        self.name = name
        self.isHD = isHD
        self.logoURL = logoURL
    }

}
