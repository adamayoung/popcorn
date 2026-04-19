//
//  TVChannel.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Represents a TV channel in the domain model.
///
public struct TVChannel: Identifiable, Equatable, Sendable {

    public let id: String

    public let name: String

    public let isHD: Bool

    public let logoURL: URL?

    public let channelNumbers: [TVChannelNumber]

    public init(
        id: String,
        name: String,
        isHD: Bool,
        logoURL: URL?,
        channelNumbers: [TVChannelNumber]
    ) {
        self.id = id
        self.name = name
        self.isHD = isHD
        self.logoURL = logoURL
        self.channelNumbers = channelNumbers
    }

}
