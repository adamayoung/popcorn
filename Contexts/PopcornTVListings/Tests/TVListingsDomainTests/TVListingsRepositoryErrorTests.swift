//
//  TVListingsRepositoryErrorTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TVListingsDomain

@Suite("TVListingsRepositoryError")
struct TVListingsRepositoryErrorTests {

    @Test("remote case preserves underlying error")
    func remotePreservesUnderlyingError() {
        let underlying = NSError(domain: "test", code: 1)

        let error = TVListingsRepositoryError.remote(underlying)

        if case .remote(let wrapped) = error {
            #expect((wrapped as NSError?) == underlying)
        } else {
            Issue.record("Expected remote case")
        }
    }

    @Test("local case preserves underlying error")
    func localPreservesUnderlyingError() {
        let underlying = NSError(domain: "test", code: 2)

        let error = TVListingsRepositoryError.local(underlying)

        if case .local(let wrapped) = error {
            #expect((wrapped as NSError?) == underlying)
        } else {
            Issue.record("Expected local case")
        }
    }

    @Test("unknown case preserves underlying error")
    func unknownPreservesUnderlyingError() {
        let underlying = NSError(domain: "test", code: 3)

        let error = TVListingsRepositoryError.unknown(underlying)

        if case .unknown(let wrapped) = error {
            #expect((wrapped as NSError?) == underlying)
        } else {
            Issue.record("Expected unknown case")
        }
    }

}
