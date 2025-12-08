//
//  SearchMediaUseCase.swift
//  PopcornSearch
//
//  Created by Adam Young on 25/11/2025.
//

import Foundation

public protocol SearchMediaUseCase: Sendable {

    func execute(query: String) async throws(SearchMediaError) -> [MediaPreviewDetails]

    func execute(query: String, page: Int) async throws(SearchMediaError) -> [MediaPreviewDetails]

}
