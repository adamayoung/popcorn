//
//  DefaultFetchAllGenresUseCase.swift
//  PopcornGenres
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import GenresDomain

final class DefaultFetchAllGenresUseCase: FetchAllGenresUseCase {

    private let repository: any GenreRepository
    private let appConfigurationProvider: any AppConfigurationProviding
    private let genreBackdropProvider: any GenreBackdropProviding

    init(
        repository: some GenreRepository,
        appConfigurationProvider: some AppConfigurationProviding,
        genreBackdropProvider: some GenreBackdropProviding
    ) {
        self.repository = repository
        self.appConfigurationProvider = appConfigurationProvider
        self.genreBackdropProvider = genreBackdropProvider
    }

    func execute() async throws(FetchAllGenresError) -> [GenreDetailsExtended] {
        let movieGenres: [Genre]
        let tvSeriesGenres: [Genre]
        let appConfiguration: AppConfiguration
        do {
            (movieGenres, tvSeriesGenres, appConfiguration) = try await (
                repository.movieGenres(),
                repository.tvSeriesGenres(),
                appConfigurationProvider.appConfiguration()
            )
        } catch let error as GenreRepositoryError {
            throw FetchAllGenresError(error)
        } catch let error as AppConfigurationProviderError {
            throw FetchAllGenresError(error)
        } catch {
            throw .unknown(error)
        }

        let mergedGenres = mergeGenres(movieGenres: movieGenres, tvSeriesGenres: tvSeriesGenres)
        let imagesConfiguration = appConfiguration.images
        let backdropPaths = await fetchBackdropPaths(for: mergedGenres)

        let mapper = GenreDetailsExtendedMapper()
        return mergedGenres.map { genre in
            let backdropURLSet = imagesConfiguration.backdropURLSet(for: backdropPaths[genre.id])
            return mapper.map(genre, backdropURLSet: backdropURLSet)
        }
    }

}

extension DefaultFetchAllGenresUseCase {

    private func mergeGenres(movieGenres: [Genre], tvSeriesGenres: [Genre]) -> [Genre] {
        var lookup = [Genre.ID: Genre]()

        for genre in movieGenres {
            lookup[genre.id] = genre
        }

        for genre in tvSeriesGenres where lookup[genre.id] == nil {
            lookup[genre.id] = genre
        }

        return lookup.values.sorted { $0.name < $1.name }
    }

    private func fetchBackdropPaths(for genres: [Genre]) async -> [Genre.ID: URL] {
        await withTaskGroup(of: (Genre.ID, URL?).self) { group in
            for genre in genres {
                group.addTask { [genreBackdropProvider] in
                    let path = try? await genreBackdropProvider.backdropPath(forGenreID: genre.id)
                    return (genre.id, path)
                }
            }

            var results = [Genre.ID: URL]()
            for await (genreID, path) in group {
                if let path {
                    results[genreID] = path
                }
            }
            return results
        }
    }

}
