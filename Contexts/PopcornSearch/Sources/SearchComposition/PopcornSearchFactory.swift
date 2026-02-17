//
//  PopcornSearchFactory.swift
//  PopcornSearch
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SearchApplication

public protocol PopcornSearchFactory: Sendable {

    func makeSearchMediaUseCase() -> SearchMediaUseCase

    func makeFetchMediaSearchHistory() -> FetchMediaSearchHistoryUseCase

    func makeAddMediaSearchHistoryEntryUseCase() -> AddMediaSearchHistoryEntryUseCase

}
