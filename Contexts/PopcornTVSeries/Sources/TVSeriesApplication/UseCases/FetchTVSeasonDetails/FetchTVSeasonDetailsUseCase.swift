//
//  FetchTVSeasonDetailsUseCase.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public protocol FetchTVSeasonDetailsUseCase: Sendable {

    func execute(
        tvSeriesID: Int,
        seasonNumber: Int
    ) async throws(FetchTVSeasonDetailsError) -> TVSeasonDetailsSummary

}
