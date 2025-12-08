//
//  FetchTrendingPeopleUseCase.swift
//  TrendingKit
//
//  Created by Adam Young on 09/06/2025.
//

import Foundation

public protocol FetchTrendingPeopleUseCase: Sendable {

    func execute() async throws(FetchTrendingPeopleError) -> [PersonPreviewDetails]

    func execute(page: Int) async throws(FetchTrendingPeopleError) -> [PersonPreviewDetails]

}
