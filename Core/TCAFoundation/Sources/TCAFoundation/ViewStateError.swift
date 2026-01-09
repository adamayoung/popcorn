//
//  ViewStateError.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

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
public struct ViewStateError: Equatable, Sendable {

    /// A user-friendly error message.
    public let message: String

    /// A detailed description of the underlying error for debugging.
    public let underlyingError: String?

    /// Whether the operation that caused this error can be retried.
    public let isRetryable: Bool

    /// Creates a new view state error with explicit values.
    ///
    /// - Parameters:
    ///   - message: A user-friendly error message.
    ///   - underlyingError: A detailed description of the underlying error.
    ///   - isRetryable: Whether the operation can be retried. Defaults to `true`.
    public init(
        message: String,
        underlyingError: String? = nil,
        isRetryable: Bool = true
    ) {
        self.message = message
        self.underlyingError = underlyingError
        self.isRetryable = isRetryable
    }

    /// Creates a new view state error from any `Error`.
    ///
    /// - Parameters:
    ///   - error: The underlying error.
    ///   - isRetryable: Whether the operation can be retried. Defaults to `true`.
    public init(_ error: any Error, isRetryable: Bool = true) {
        self.message = error.localizedDescription
        self.underlyingError = String(describing: error)
        self.isRetryable = isRetryable
    }

}
