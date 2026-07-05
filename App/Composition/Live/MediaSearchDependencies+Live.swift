//
//  MediaSearchDependencies+Live.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import GenresApplication
import GenresComposition
import MediaSearchFeature
import SearchApplication
import SearchComposition

extension MediaSearchDependencies {

    /// Builds the production dependencies from the app's shared services.
    static func live(services: AppServices) -> MediaSearchDependencies {
        let fetchAllGenres = services.genresFactory.makeFetchAllGenresUseCase()
        let searchMedia = services.searchFactory.makeSearchMediaUseCase()
        let fetchMediaSearchHistory = services.searchFactory.makeFetchMediaSearchHistory()
        let addMediaSearchHistoryEntry = services.searchFactory.makeAddMediaSearchHistoryEntryUseCase()

        return MediaSearchDependencies(
            fetchGenres: {
                let genres = try await fetchAllGenres.execute()
                let mapper = GenreMapper()
                return genres.map(mapper.map)
            },
            search: { query in
                let media = try await searchMedia.execute(query: query)
                let mapper = MediaPreviewMapper()
                return media.map(mapper.map)
            },
            fetchMediaSearchHistory: {
                let media = try await fetchMediaSearchHistory.execute()
                let mapper = MediaPreviewMapper()
                return media.map(mapper.map)
            },
            addMovieSearchHistoryEntry: { id in
                try await addMediaSearchHistoryEntry.execute(movieID: id)
            },
            addTVSeriesSearchHistoryEntry: { id in
                try await addMediaSearchHistoryEntry.execute(tvSeriesID: id)
            },
            addPersonSearchHistoryEntry: { id in
                try await addMediaSearchHistoryEntry.execute(personID: id)
            }
        )
    }

}
