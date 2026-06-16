//
//  Channel.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Represents a TV channel in the domain model.
///
public struct Channel: Identifiable, Equatable, Sendable {

    public let id: String

    public let name: String

    public let type: ChannelType

    public let isHD: Bool

    public let logoURL: URL?

    public let channelNumbers: [ChannelNumber]

    public init(
        id: String,
        name: String,
        type: ChannelType,
        isHD: Bool,
        logoURL: URL?,
        channelNumbers: [ChannelNumber]
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.isHD = isHD
        self.logoURL = logoURL
        self.channelNumbers = channelNumbers
    }

}
