//
//  GameQuestion.swift
//  PlotRemixGameFeature
//
//  Created by Adam Young on 05/12/2025.
//

import Foundation

public struct GameQuestion: Identifiable, Sendable, Equatable {

    public let id: UUID
    public let movie: Movie
    public let riddle: String

    public init(
        id: UUID,
        movie: Movie,
        riddle: String
    ) {
        self.id = id
        self.movie = movie
        self.riddle = riddle
    }

}
