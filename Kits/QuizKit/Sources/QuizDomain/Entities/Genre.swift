//
//  Genre.swift
//  QuizKit
//
//  Created by Adam Young on 05/12/2025.
//

import Foundation

public struct Genre: Sendable, Equatable, Identifiable {

    public let id: Int
    public let name: String

    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }

}
