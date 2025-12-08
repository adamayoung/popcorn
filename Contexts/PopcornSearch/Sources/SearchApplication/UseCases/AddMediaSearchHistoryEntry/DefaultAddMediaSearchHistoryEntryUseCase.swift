//
//  DefaultAddMediaSearchHistoryEntryUseCase.swift
//  PopcornSearch
//
//  Created by Adam Young on 04/12/2025.
//

import Foundation
import SearchDomain

final class DefaultAddMediaSearchHistoryEntryUseCase: AddMediaSearchHistoryEntryUseCase {

    private let repository: any MediaRepository

    init(repository: some MediaRepository) {
        self.repository = repository
    }

    func execute(movieID: Int) async throws(AddMediaSearchHistoryEntryError) {
        let entry = MovieSearchHistoryEntry(id: movieID, timestamp: .now)

        do {
            try await repository.saveMovieSearchHistoryEntry(entry)
        } catch let error {
            throw AddMediaSearchHistoryEntryError(error)
        }
    }

    func execute(tvSeriesID: Int) async throws(AddMediaSearchHistoryEntryError) {
        let entry = TVSeriesSearchHistoryEntry(id: tvSeriesID, timestamp: .now)

        do {
            try await repository.saveTVSeriesSearchHistoryEntry(entry)
        } catch let error {
            throw AddMediaSearchHistoryEntryError(error)
        }
    }

    func execute(personID: Int) async throws(AddMediaSearchHistoryEntryError) {
        let entry = PersonSearchHistoryEntry(id: personID, timestamp: .now)

        do {
            try await repository.savePersonSearchHistoryEntry(entry)
        } catch let error {
            throw AddMediaSearchHistoryEntryError(error)
        }
    }

}
