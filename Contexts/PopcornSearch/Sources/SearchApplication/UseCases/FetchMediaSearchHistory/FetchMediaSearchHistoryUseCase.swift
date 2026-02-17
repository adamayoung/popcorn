//
//  FetchMediaSearchHistoryUseCase.swift
//  PopcornSearch
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public protocol FetchMediaSearchHistoryUseCase: Sendable {

    func execute() async throws(FetchMediaSearchHistoryError) -> [MediaPreviewDetails]

}
