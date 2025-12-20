//
//  DefaultFetchMovieGenresUseCase.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import GenresDomain

final class DefaultFetchMovieGenresUseCase: FetchMovieGenresUseCase {

    private let repository: any GenreRepository

    init(repository: some GenreRepository) {
        self.repository = repository
    }

    func execute() async throws(FetchMovieGenresError) -> [Genre] {
        let genres: [Genre]
        do {
            genres = try await repository.movieGenres()
        } catch let error {
            throw FetchMovieGenresError(error)
        }

        return genres
    }

}
