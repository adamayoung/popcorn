//
//  AnswerOption.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public struct AnswerOption: Identifiable, Sendable, Equatable {

    public let id: Int
    public let title: String
    public let isCorrect: Bool

    public init(id: Int, title: String, isCorrect: Bool) {
        self.id = id
        self.title = title
        self.isCorrect = isCorrect
    }

}
