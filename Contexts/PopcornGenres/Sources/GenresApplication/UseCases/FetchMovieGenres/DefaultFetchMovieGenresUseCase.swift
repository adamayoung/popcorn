//
//  DefaultFetchMovieGenresUseCase.swift
//  PopcornGenres
//
//  Created by Adam Young on 06/06/2025.
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
