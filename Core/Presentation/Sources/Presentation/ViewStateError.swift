//
//  ViewStateError.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

/// An equatable error type for use with ``ViewState``.
///
/// This provides an `Equatable` wrapper around errors for use in TCA state,
/// since `Error` itself does not conform to `Equatable`.
///
/// Example usage:
/// ```swift
/// do {
///     let data = try await fetchData()
///     await send(.loaded(data))
/// } catch {
///     await send(.loadFailed(ViewStateError(error)))
/// }
/// ```
public struct ViewStateError: LocalizedError, Equatable, Sendable {

    /// A user-friendly error message.
    public let message: String

    /// The reason the error occurred.
    public let reason: String?

    /// A suggestion for how to recover from the error.
    public let recovery: String?

    /// A detailed description of the underlying error for debugging.
    public let underlyingError: String?

    /// Whether the operation that caused this error can be retried.
    public let isRetryable: Bool

    public var errorDescription: String? {
        message
    }

    public var failureReason: String? {
        reason
    }

    public var recoverySuggestion: String? {
        recovery
    }

    /// Creates a new view state error with explicit values.
    ///
    /// - Parameters:
    ///   - message: A user-friendly error message.
    ///   - reason: The reason the error occurred.
    ///   - recovery: A suggestion for how to recover from the error.
    ///   - underlyingError: A detailed description of the underlying error.
    ///   - isRetryable: Whether the operation can be retried. Defaults to `true`.
    public init(
        message: String,
        reason: String? = nil,
        recovery: String? = nil,
        underlyingError: String? = nil,
        isRetryable: Bool = true
    ) {
        self.message = message
        self.reason = reason
        self.recovery = recovery
        self.underlyingError = underlyingError
        self.isRetryable = isRetryable
    }

    /// Creates a new view state error from any `Error`.
    ///
    /// - Parameters:
    ///   - error: The underlying error.
    ///   - isRetryable: Whether the operation can be retried. Defaults to `true`.
    public init(_ error: any Error, isRetryable: Bool = true) {
        let localizedError = error as? any LocalizedError
        self.message = error.localizedDescription
        self.reason = localizedError?.failureReason
        self.recovery = localizedError?.recoverySuggestion
        self.underlyingError = String(describing: error)
        self.isRetryable = isRetryable
    }

}
