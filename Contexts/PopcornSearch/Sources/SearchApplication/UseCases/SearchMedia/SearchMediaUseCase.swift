//
//  SearchMediaUseCase.swift
//  PopcornSearch
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public protocol SearchMediaUseCase: Sendable {

    func execute(query: String) async throws(SearchMediaError) -> [MediaPreviewDetails]

    func execute(query: String, page: Int) async throws(SearchMediaError) -> [MediaPreviewDetails]

}
