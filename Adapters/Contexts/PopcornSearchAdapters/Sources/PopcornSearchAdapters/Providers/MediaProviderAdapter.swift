//
//  MediaProviderAdapter.swift
//  PopcornSearchAdapters
//
//  Created by Adam Young on 04/12/2025.
//

import ConfigurationApplication
import CoreDomain
import MoviesApplication
import PeopleApplication
import SearchDomain
import TVApplication

public struct MediaProviderAdapter: MediaProviding {

    private let fetchMovieUseCase: any FetchMovieDetailsUseCase
    private let fetchTVSeriesUseCase: any FetchTVSeriesDetailsUseCase
    private let fetchPersonUseCase: any FetchPersonDetailsUseCase

    public init(
        fetchMovieUseCase: some FetchMovieDetailsUseCase,
        fetchTVSeriesUseCase: some FetchTVSeriesDetailsUseCase,
        fetchPersonUseCase: some FetchPersonDetailsUseCase
    ) {
        self.fetchMovieUseCase = fetchMovieUseCase
        self.fetchTVSeriesUseCase = fetchTVSeriesUseCase
        self.fetchPersonUseCase = fetchPersonUseCase
    }

    public func movie(withID id: Int) async throws(MediaProviderError) -> MoviePreview {
        let movie: MovieDetails
        do {
            movie = try await fetchMovieUseCase.execute(id: id)
        } catch let error {
            throw MediaProviderError(error)
        }

        return MoviePreview(
            id: movie.id,
            title: movie.title,
            overview: movie.overview ?? "",
            posterPath: movie.posterURLSet?.path,
            backdropPath: movie.backdropURLSet?.path
        )
    }

    public func tvSeries(withID id: Int) async throws(MediaProviderError) -> TVSeriesPreview {
        let tvSeries: TVSeriesDetails
        do {
            tvSeries = try await fetchTVSeriesUseCase.execute(id: id)
        } catch let error {
            throw MediaProviderError(error)
        }

        return TVSeriesPreview(
            id: tvSeries.id,
            name: tvSeries.name,
            overview: tvSeries.overview ?? "",
            posterPath: tvSeries.posterURLSet?.path,
            backdropPath: tvSeries.backdropURLSet?.path
        )
    }

    public func person(withID id: Int) async throws(MediaProviderError) -> PersonPreview {
        let person: PersonDetails
        do {
            person = try await fetchPersonUseCase.execute(id: id)
        } catch let error {
            throw MediaProviderError(error)
        }

        return PersonPreview(
            id: person.id,
            name: person.name,
            knownForDepartment: person.knownForDepartment,
            gender: person.gender,
            profilePath: person.profileURLSet?.path
        )
    }

}

extension MediaProviderError {

    fileprivate init(_ error: FetchMovieDetailsError) {
        switch error {
        case .notFound:
            self = .notFound
        case .unauthorised:
            self = .unauthorised
        default:
            self = .unknown(error)
        }
    }

    fileprivate init(_ error: FetchTVSeriesDetailsError) {
        switch error {
        case .notFound:
            self = .notFound
        case .unauthorised:
            self = .unauthorised
        default:
            self = .unknown(error)
        }
    }

    fileprivate init(_ error: FetchPersonDetailsError) {
        switch error {
        case .notFound:
            self = .notFound
        case .unauthorised:
            self = .unauthorised
        default:
            self = .unknown(error)
        }
    }

}
