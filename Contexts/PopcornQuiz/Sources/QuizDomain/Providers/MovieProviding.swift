//
//  MovieProviding.swift
//  PopcornQuiz
//
//  Created by Adam Young on 05/12/2025.
//

import Foundation

public protocol MovieProviding: Sendable {

    func randomMovie() async throws -> Movie

}
