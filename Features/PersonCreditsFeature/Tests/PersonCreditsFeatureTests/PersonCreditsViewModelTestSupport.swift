//
//  PersonCreditsViewModelTestSupport.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import PersonCreditsFeature
import Presentation

@MainActor
final class SpyPersonCreditsNavigator: PersonCreditsNavigating {

    private(set) var openedMovieID: Int?
    private(set) var openedTVSeriesID: Int?

    func openMovieDetails(id: Int) {
        openedMovieID = id
    }

    func openTVSeriesDetails(id: Int) {
        openedTVSeriesID = id
    }

}

enum PersonCreditsTestSupport {

    @MainActor
    static func makeViewModel(
        personID: Int = 1,
        dependencies: PersonCreditsDependencies = stubDependencies(credits: []),
        navigator: any PersonCreditsNavigating = SpyPersonCreditsNavigator(),
        viewState: ViewState<PersonCreditsViewSnapshot> = .initial
    ) -> PersonCreditsViewModel {
        PersonCreditsViewModel(
            personID: personID,
            dependencies: dependencies,
            navigator: navigator,
            viewState: viewState
        )
    }

    static func stubDependencies(credits: [CreditItem]) -> PersonCreditsDependencies {
        PersonCreditsDependencies(
            fetchCredits: { _ in credits }
        )
    }

    static func failingDependencies(error: Error = PersonCreditsTestError.failed) -> PersonCreditsDependencies {
        PersonCreditsDependencies(
            fetchCredits: { _ in throw error }
        )
    }

}

enum PersonCreditsTestError: Error {
    case failed
}
