//
//  SpanStatusMappingTests.swift
//  ObservabilityAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Observability
@testable import ObservabilityAdapters
import Sentry
import Testing

@Suite("SpanStatus Mapping Tests")
struct SpanStatusMappingTests {

    @Test("Maps ok status to Sentry ok status")
    func mapsOkStatus() {
        let status = SpanStatus.ok

        let sentryStatus = status.sentryStatus

        #expect(sentryStatus == .ok)
    }

    @Test("Maps cancelled status to Sentry cancelled status")
    func mapsCancelledStatus() {
        let status = SpanStatus.cancelled

        let sentryStatus = status.sentryStatus

        #expect(sentryStatus == .cancelled)
    }

    @Test("Maps unknownError status to Sentry unknownError status")
    func mapsUnknownErrorStatus() {
        let status = SpanStatus.unknownError

        let sentryStatus = status.sentryStatus

        #expect(sentryStatus == .unknownError)
    }

    @Test("Maps invalidArgument status to Sentry invalidArgument status")
    func mapsInvalidArgumentStatus() {
        let status = SpanStatus.invalidArgument

        let sentryStatus = status.sentryStatus

        #expect(sentryStatus == .invalidArgument)
    }

    @Test("Maps deadlineExceeded status to Sentry deadlineExceeded status")
    func mapsDeadlineExceededStatus() {
        let status = SpanStatus.deadlineExceeded

        let sentryStatus = status.sentryStatus

        #expect(sentryStatus == .deadlineExceeded)
    }

    @Test("Maps notFound status to Sentry notFound status")
    func mapsNotFoundStatus() {
        let status = SpanStatus.notFound

        let sentryStatus = status.sentryStatus

        #expect(sentryStatus == .notFound)
    }

    @Test("Maps permissionDenied status to Sentry permissionDenied status")
    func mapsPermissionDeniedStatus() {
        let status = SpanStatus.permissionDenied

        let sentryStatus = status.sentryStatus

        #expect(sentryStatus == .permissionDenied)
    }

    @Test("Maps resourceExhausted status to Sentry resourceExhausted status")
    func mapsResourceExhaustedStatus() {
        let status = SpanStatus.resourceExhausted

        let sentryStatus = status.sentryStatus

        #expect(sentryStatus == .resourceExhausted)
    }

    @Test("Maps unimplemented status to Sentry unimplemented status")
    func mapsUnimplementedStatus() {
        let status = SpanStatus.unimplemented

        let sentryStatus = status.sentryStatus

        #expect(sentryStatus == .unimplemented)
    }

    @Test("Maps unavailable status to Sentry unavailable status")
    func mapsUnavailableStatus() {
        let status = SpanStatus.unavailable

        let sentryStatus = status.sentryStatus

        #expect(sentryStatus == .unavailable)
    }

    @Test("Maps internalError status to Sentry internalError status")
    func mapsInternalErrorStatus() {
        let status = SpanStatus.internalError

        let sentryStatus = status.sentryStatus

        #expect(sentryStatus == .internalError)
    }

    @Test(
        "Maps all SpanStatus values to corresponding SentrySpanStatus",
        arguments: [
            (SpanStatus.ok, SentrySpanStatus.ok),
            (SpanStatus.cancelled, SentrySpanStatus.cancelled),
            (SpanStatus.unknownError, SentrySpanStatus.unknownError),
            (SpanStatus.invalidArgument, SentrySpanStatus.invalidArgument),
            (SpanStatus.deadlineExceeded, SentrySpanStatus.deadlineExceeded),
            (SpanStatus.notFound, SentrySpanStatus.notFound),
            (SpanStatus.permissionDenied, SentrySpanStatus.permissionDenied),
            (SpanStatus.resourceExhausted, SentrySpanStatus.resourceExhausted),
            (SpanStatus.unimplemented, SentrySpanStatus.unimplemented),
            (SpanStatus.unavailable, SentrySpanStatus.unavailable),
            (SpanStatus.internalError, SentrySpanStatus.internalError)
        ]
    )
    func mapsAllStatusValues(status: SpanStatus, expectedSentryStatus: SentrySpanStatus) {
        let sentryStatus = status.sentryStatus

        #expect(sentryStatus == expectedSentryStatus)
    }

}
