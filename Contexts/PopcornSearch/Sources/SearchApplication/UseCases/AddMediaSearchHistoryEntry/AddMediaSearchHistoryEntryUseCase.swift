//
//  AddMediaSearchHistoryEntryUseCase.swift
//  PopcornSearch
//
//  Created by Adam Young on 04/12/2025.
//

import Foundation

public protocol AddMediaSearchHistoryEntryUseCase: Sendable {

    func execute(movieID: Int) async throws(AddMediaSearchHistoryEntryError)

    func execute(tvSeriesID: Int) async throws(AddMediaSearchHistoryEntryError)

    func execute(personID: Int) async throws(AddMediaSearchHistoryEntryError)

}
