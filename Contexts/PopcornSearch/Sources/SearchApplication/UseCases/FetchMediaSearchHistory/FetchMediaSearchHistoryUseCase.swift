//
//  FetchMediaSearchHistoryUseCase.swift
//  PopcornSearch
//
//  Created by Adam Young on 04/12/2025.
//

import Foundation

public protocol FetchMediaSearchHistoryUseCase: Sendable {

    func execute() async throws(FetchMediaSearchHistoryError) -> [MediaPreviewDetails]

}
