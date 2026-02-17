//
//  ImageURLSet.swift
//  CoreDomain
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public struct ImageURLSet: Sendable, Equatable {

    public let path: URL
    public let thumbnail: URL
    public let card: URL
    public let detail: URL
    public let full: URL

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
