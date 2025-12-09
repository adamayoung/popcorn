//
//  ExploreFeature.swift
//  ExploreFeature
//
//  Created by Adam Young on 21/11/2025.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct ExploreFeature: Sendable {

    @Dependency(\.explore) private var explore: ExploreClient

    @ObservableState
    public struct State {
        public struct ItemCollectionState<Item> {
            var items: [Item]
            var isReady: Bool { !items.isEmpty }

            public init(items: [Item] = []) {
                self.items = items
            }
        }

        var discoverMovies: ItemCollectionState<MoviePreview>
        var trendingMovies: ItemCollectionState<MoviePreview>
        var popularMovies: ItemCollectionState<MoviePreview>
        var trendingTVSeries: ItemCollectionState<TVSeriesPreview>
        var trendingPeople: ItemCollectionState<PersonPreview>

        var isReady: Bool {
            discoverMovies.isReady
                && trendingMovies.isReady
                && popularMovies.isReady
                && trendingTVSeries.isReady
                && trendingPeople.isReady
        }

        public init(
            discoverMovies: ItemCollectionState<MoviePreview> = .init(),
            trendingMovies: ItemCollectionState<MoviePreview> = .init(),
            popularMovies: ItemCollectionState<MoviePreview> = .init(),
            trendingTVSeries: ItemCollectionState<TVSeriesPreview> = .init(),
            trendingPeople: ItemCollectionState<PersonPreview> = .init()
        ) {
            self.discoverMovies = discoverMovies
            self.trendingMovies = trendingMovies
            self.popularMovies = popularMovies
            self.trendingTVSeries = trendingTVSeries
            self.trendingPeople = trendingPeople
        }
    }

    public enum Action {
        case load
        case discoverMoviesLoaded([MoviePreview])
        case trendingMoviesLoaded([MoviePreview])
        case popularMoviesLoaded([MoviePreview])
        case trendingTVSeriesLoaded([TVSeriesPreview])
        case trendingPeopleLoaded([PersonPreview])
        case navigate(Navigation)
    }

    public enum Navigation: Equatable, Hashable {
        case movieDetails(id: Int, transitionID: String? = nil)
        case tvSeriesDetails(id: Int, transitionID: String? = nil)
        case personDetails(id: Int, transitionID: String? = nil)
    }

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .load:
                //                guard !state.isReady else {
                //                    return .none
                //                }

                return handleFetchAll()
            case .discoverMoviesLoaded(let movies):
                state.discoverMovies.items = movies
                return .none
            case .trendingMoviesLoaded(let movies):
                state.trendingMovies.items = movies
                return .none
            case .popularMoviesLoaded(let movies):
                state.popularMovies.items = movies
                return .none
            case .trendingTVSeriesLoaded(let tvSeries):
                state.trendingTVSeries.items = tvSeries
                return .none
            case .trendingPeopleLoaded(let people):
                state.trendingPeople.items = people
                return .none
            case .navigate:
                return .none
            }
        }
    }

}

extension ExploreFeature {

    private func handleFetchAll() -> EffectOf<Self> {
        .merge(
            handleFetchDiscoverMovies(),
            handleFetchTrendingMovies(),
            handleFetchPopularMovies(),
            handleFetchTrendingTVSeries(),
            handleFetchTrendingPeople()
        )
    }

    private func handleFetchDiscoverMovies() -> EffectOf<Self> {
        .run { send in
            do {
                let movies = try await explore.fetchDiscoverMovies()
                await send(.discoverMoviesLoaded(movies))
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    private func handleFetchTrendingMovies() -> EffectOf<Self> {
        .run { send in
            do {
                let movies = try await explore.fetchTrendingMovies()
                await send(.trendingMoviesLoaded(movies))
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    private func handleFetchPopularMovies() -> EffectOf<Self> {
        .run { send in
            do {
                let movies = try await explore.fetchPopularMovies()
                await send(.popularMoviesLoaded(movies))
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    private func handleFetchTrendingTVSeries() -> EffectOf<Self> {
        .run { send in
            do {
                let tvSeries = try await explore.fetchTrendingTVSeries()
                await send(.trendingTVSeriesLoaded(tvSeries))
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    private func handleFetchTrendingPeople() -> EffectOf<Self> {
        .run { send in
            do {
                let people = try await explore.fetchTrendingPeople()
                await send(.trendingPeopleLoaded(people))
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

}
