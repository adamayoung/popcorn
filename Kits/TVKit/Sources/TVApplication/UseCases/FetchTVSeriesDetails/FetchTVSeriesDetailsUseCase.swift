//
//  FetchTVSeriesDetailsUseCase.swift
//  TVKit
//
//  Created by Adam Young on 03/06/2025.
//

import Foundation
import TVDomain

public protocol FetchTVSeriesDetailsUseCase: Sendable {

    func execute(id: Int) async throws(FetchTVSeriesDetailsError) -> TVSeriesDetails

}
