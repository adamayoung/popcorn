//
//  ViewState.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import CasePaths

/// A generic view state enum for TCA features.
///
/// Use this to represent the loading lifecycle of a view:
/// - `initial`: Before any data has been requested
/// - `loading`: While data is being fetched
/// - `ready`: Data has been successfully loaded
/// - `error`: An error occurred during loading
///
/// Example usage:
/// ```swift
/// @ObservableState
/// struct State {
///     var viewState: ViewState<MovieDetails> = .initial
/// }
/// ```
@CasePathable
public enum ViewState<Content: Equatable & Sendable>: Equatable, Sendable {
    case initial
    case loading
    case ready(Content)
    case error(ViewStateError)
}

public extension ViewState {

    /// Returns `true` if the view state is `initial`.
    var isInitial: Bool {
        if case .initial = self { true } else { false }
    }

    /// Returns `true` if the view state is `loading`.
    var isLoading: Bool {
        if case .loading = self { true } else { false }
    }

    /// Returns `true` if the view state is `ready`.
    var isReady: Bool {
        if case .ready = self { true } else { false }
    }

    /// Returns `true` if the view state is `error`.
    var isError: Bool {
        if case .error = self { true } else { false }
    }

    /// Returns the content if the view state is `ready`, otherwise `nil`.
    var content: Content? {
        if case .ready(let content) = self { content } else { nil }
    }

    /// Returns the error if the view state is `error`, otherwise `nil`.
    var error: ViewStateError? {
        if case .error(let error) = self { error } else { nil }
    }

}
