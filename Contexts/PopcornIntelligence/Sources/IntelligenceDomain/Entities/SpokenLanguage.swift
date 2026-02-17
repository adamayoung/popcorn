//
//  SpokenLanguage.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

public struct SpokenLanguage: Equatable, Sendable {

    public let languageCode: String
    public let name: String

    public init(languageCode: String, name: String) {
        self.languageCode = languageCode
        self.name = name
    }

}
