//
//  LLMSessionErrorTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

@testable import IntelligenceDomain
import Testing

@Suite("LLMSessionError Tests")
struct LLMSessionErrorTests {

    @Test("toolCallFailed with message")
    func toolCallFailedWithMessage() {
        let error = LLMSessionError.toolCallFailed("Tool error")
        #expect(error.errorDescription == "Tool call failed: Tool error")
    }

    @Test("toolCallFailed with nil message")
    func toolCallFailedWithNilMessage() {
        let error = LLMSessionError.toolCallFailed(nil)
        #expect(error.errorDescription == "Tool call failed: Unknown error")
    }

    @Test("exceededContextWindowSize with message")
    func exceededContextWindowSizeWithMessage() {
        let error = LLMSessionError.exceededContextWindowSize(message: "Context too large")
        #expect(error.errorDescription == "Exceeded context window size: Context too large")
    }

    @Test("exceededContextWindowSize with nil message")
    func exceededContextWindowSizeWithNilMessage() {
        let error = LLMSessionError.exceededContextWindowSize(message: nil)
        #expect(error.errorDescription == "Exceeded context window size: Unknown")
    }

    @Test("assetsUnavailable with message")
    func assetsUnavailableWithMessage() {
        let error = LLMSessionError.assetsUnavailable(message: "Assets not found")
        #expect(error.errorDescription == "Assets unavailable: Assets not found")
    }

    @Test("guardrailViolation with message")
    func guardrailViolationWithMessage() {
        let error = LLMSessionError.guardrailViolation(message: "Violated policy")
        #expect(error.errorDescription == "Guardrail violation: Violated policy")
    }

    @Test("unsupportedGuide with message")
    func unsupportedGuideWithMessage() {
        let error = LLMSessionError.unsupportedGuide(message: "Guide not supported")
        #expect(error.errorDescription == "Unsupported guide: Guide not supported")
    }

    @Test("unsupportedLanguageOrLocale with message")
    func unsupportedLanguageOrLocaleWithMessage() {
        let error = LLMSessionError.unsupportedLanguageOrLocale(message: "Locale not supported")
        #expect(error.errorDescription == "Unsupported language or locale: Locale not supported")
    }

    @Test("decodingFailure with message")
    func decodingFailureWithMessage() {
        let error = LLMSessionError.decodingFailure(message: "Failed to decode")
        #expect(error.errorDescription == "Decoding failure: Failed to decode")
    }

    @Test("rateLimited with message")
    func rateLimitedWithMessage() {
        let error = LLMSessionError.rateLimited(message: "Too many requests")
        #expect(error.errorDescription == "Rate limited: Too many requests")
    }

    @Test("concurrentRequests with message")
    func concurrentRequestsWithMessage() {
        let error = LLMSessionError.concurrentRequests(message: "Too many concurrent requests")
        #expect(error.errorDescription == "Concurrent requests: Too many concurrent requests")
    }

    @Test("refusal with message")
    func refusalWithMessage() {
        let error = LLMSessionError.refusal(message: "Request refused")
        #expect(error.errorDescription == "Refusal: Request refused")
    }

    @Test("unknown with message")
    func unknownWithMessage() {
        let error = LLMSessionError.unknown("Something went wrong")
        #expect(error.errorDescription == "Unknown error: Something went wrong")
    }

    @Test("unknown with nil message")
    func unknownWithNilMessage() {
        let error = LLMSessionError.unknown()
        #expect(error.errorDescription == "Unknown error: Unknown")
    }

    @Test("errorDescription surfaces through localizedDescription")
    func errorDescriptionSurfacesThroughLocalizedDescription() {
        let error = LLMSessionError.refusal(message: "Content policy violation")
        #expect(error.localizedDescription == "Refusal: Content policy violation")
    }

    @Test("Equatable - same cases are equal")
    func equalitySameCases() {
        #expect(LLMSessionError.rateLimited(message: "x") == LLMSessionError.rateLimited(message: "x"))
        #expect(LLMSessionError.unknown("msg") == LLMSessionError.unknown("msg"))
        #expect(LLMSessionError.unknown() == LLMSessionError.unknown())
    }

    @Test("Equatable - different cases are not equal")
    func equalityDifferentCases() {
        #expect(LLMSessionError.rateLimited(message: "x") != LLMSessionError.refusal(message: "x"))
        #expect(LLMSessionError.unknown("a") != LLMSessionError.unknown("b"))
    }

}
