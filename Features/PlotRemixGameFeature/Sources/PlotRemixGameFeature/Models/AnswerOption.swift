//
//  AnswerOption.swift
//  PlotRemixGameFeature
//
//  Created by Adam Young on 12/12/2025.
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

extension AnswerOption {

    static var mocks: [AnswerOption] {
        [
            AnswerOption(
                id: 18975,
                title: "The Adventures of Pinocchio",
                isCorrect: false
            ),
            AnswerOption(
                id: 118,
                title: "Charlie and the Chocolate Factory",
                isCorrect: true
            ),
            AnswerOption(
                id: 18993,
                title: "Mysterious Island",
                isCorrect: false
            ),
            AnswerOption(
                id: 19059,
                title: "Dead Fish",
                isCorrect: false
            )
        ]
    }

}
