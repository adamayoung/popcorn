//
//  MediaProviderAdapter.swift
//  PopcornSearchAdapters
//
//  Copyright © 2025 Adam Young.
//

import ConfigurationApplication
import CoreDomain
import MoviesApplication
import PeopleApplication
import SearchDomain
import TVSeriesApplication

///
/// An adapter that provides media content for the search domain.
///
/// Bridges the movies, TV series, and people application layers to the search
/// domain by wrapping their respective detail use cases.
///
public struct MediaProviderAdapter: MediaProviding {

    private let fetchMovieUseCase: any FetchMovieDetailsUseCase
    private let fetchTVSeriesUseCase: any FetchTVSeriesDetailsUseCase
    private let fetchPersonUseCase: any FetchPersonDetailsUseCase

    ///
    /// Creates a media provider adapter.
    ///
    /// - Parameters:
    ///   - fetchMovieUseCase: The use case for fetching movie details.
    ///   - fetchTVSeriesUseCase: The use case for fetching TV series details.
    ///   - fetchPersonUseCase: The use case for fetching person details.
    ///
    public init(
        fetchMovieUseCase: some FetchMovieDetailsUseCase,
        fetchTVSeriesUseCase: some FetchTVSeriesDetailsUseCase,
        fetchPersonUseCase: some FetchPersonDetailsUseCase
    ) {
        self.fetchMovieUseCase = fetchMovieUseCase
        self.fetchTVSeriesUseCase = fetchTVSeriesUseCase
        self.fetchPersonUseCase = fetchPersonUseCase
    }

    ///
    /// Fetches movie preview details.
    ///
    /// - Parameter id: The identifier of the movie.
    /// - Returns: A movie preview with the specified identifier.
    /// - Throws: ``MediaProviderError`` if the movie cannot be fetched.
    ///
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
            overview: movie.overview,
            posterPath: movie.posterURLSet?.path,
            backdropPath: movie.backdropURLSet?.path
        )
    }

    ///
    /// Fetches TV series preview details.
    ///
    /// - Parameter id: The identifier of the TV series.
    /// - Returns: A TV series preview with the specified identifier.
    /// - Throws: ``MediaProviderError`` if the TV series cannot be fetched.
    ///
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
            overview: tvSeries.overview,
            posterPath: tvSeries.posterURLSet?.path,
            backdropPath: tvSeries.backdropURLSet?.path
        )
    }

    ///
    /// Fetches person preview details.
    ///
    /// - Parameter id: The identifier of the person.
    /// - Returns: A person preview with the specified identifier.
    /// - Throws: ``MediaProviderError`` if the person cannot be fetched.
    ///
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

private extension MediaProviderError {

    init(_ error: FetchMovieDetailsError) {
        switch error {
        case .notFound:
            self = .notFound
        case .unauthorised:
            self = .unauthorised
        default:
            self = .unknown(error)
        }
    }

    init(_ error: FetchTVSeriesDetailsError) {
        switch error {
        case .notFound:
            self = .notFound
        case .unauthorised:
            self = .unauthorised
        default:
            self = .unknown(error)
        }
    }

    init(_ error: FetchPersonDetailsError) {
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
