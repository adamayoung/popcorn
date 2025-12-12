//
//  Game.swift
//  PlotRemixGameFeature
//
//  Created by Adam Young on 11/12/2025.
//

import Foundation

public struct Game: Identifiable, Sendable {

    public let id: UUID
    public let questions: [GameQuestion]

    public init(
        id: UUID,
        questions: [GameQuestion]
    ) {
        self.id = id
        self.questions = questions
    }

}
