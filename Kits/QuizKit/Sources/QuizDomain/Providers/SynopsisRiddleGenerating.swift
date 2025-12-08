//
//  SynopsisRiddleGenerating.swift
//  QuizKit
//
//  Created by Adam Young on 05/12/2025.
//

import Foundation

public protocol SynopsisRiddleGenerating: Sendable {

    func riddle(for movie: Movie, theme: QuizTheme) async throws -> String

}
