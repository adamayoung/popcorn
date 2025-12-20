//
//  FetchMediaSearchHistoryUseCase.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public protocol FetchMediaSearchHistoryUseCase: Sendable {

    func execute() async throws(FetchMediaSearchHistoryError) -> [MediaPreviewDetails]

}
