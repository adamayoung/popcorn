//
//  DefaultFetchTVSeriesGenresUseCase.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import GenresDomain

final class DefaultFetchTVSeriesGenresUseCase: FetchTVSeriesGenresUseCase {

    private let repository: any GenreRepository

    init(repository: some GenreRepository) {
        self.repository = repository
    }

    func execute() async throws(FetchTVSeriesGenresError) -> [Genre] {
        let genres: [Genre]
        do {
            genres = try await repository.tvSeriesGenres()
        } catch let error {
            throw FetchTVSeriesGenresError(error)
        }

        return genres
    }

}
