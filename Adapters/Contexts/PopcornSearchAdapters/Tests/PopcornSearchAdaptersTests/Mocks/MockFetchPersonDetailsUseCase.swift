//
//  MockFetchPersonDetailsUseCase.swift
//  PopcornSearchAdapters
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation
import PeopleApplication

final class MockFetchPersonDetailsUseCase: FetchPersonDetailsUseCase, @unchecked Sendable {

    struct ExecuteCall: Equatable {
        let id: Int
    }

    var executeCallCount = 0
    var executeCalledWith: [ExecuteCall] = []
    var executeStub: Result<PersonDetails, FetchPersonDetailsError>?

    func execute(id: Int) async throws(FetchPersonDetailsError) -> PersonDetails {
        executeCallCount += 1
        executeCalledWith.append(ExecuteCall(id: id))

        guard let stub = executeStub else {
            throw .unknown(nil)
        }

        switch stub {
        case .success(let personDetails):
            return personDetails
        case .failure(let error):
            throw error
        }
    }

}
