//
//  FetchTrendingPeopleUseCase.swift
//  PopcornTrending
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public protocol FetchTrendingPeopleUseCase: Sendable {

    func execute() async throws(FetchTrendingPeopleError) -> [PersonPreviewDetails]

    func execute(page: Int) async throws(FetchTrendingPeopleError) -> [PersonPreviewDetails]

}
