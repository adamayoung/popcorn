//
//  AddMediaSearchHistoryEntryUseCase.swift
//  PopcornSearch
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public protocol AddMediaSearchHistoryEntryUseCase: Sendable {

    func execute(movieID: Int) async throws(AddMediaSearchHistoryEntryError)

    func execute(tvSeriesID: Int) async throws(AddMediaSearchHistoryEntryError)

    func execute(personID: Int) async throws(AddMediaSearchHistoryEntryError)

}
