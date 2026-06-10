//
//  ViewState.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

/// A generic view state enum for MVVM view models.
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

    /// Records the outcome of a failed `.task`-driven load.
    ///
    /// SwiftUI cancels a view's `.task` when it disappears (or its `id` changes),
    /// which surfaces in a load's `catch` as a `CancellationError` (or, for
    /// in-flight networking, a cancelled `URLError`). That is **not** a real
    /// failure: committing `.error` would flash a spurious retry screen on long-
    /// lived tab view models, and leaving `.loading` would block the next
    /// `.task(id:)` run behind the `!isLoading` guard. So on cancellation this
    /// resets `.loading` back to `.initial` (letting the next run re-fetch) and
    /// leaves any other state untouched; genuine failures become `.error`.
    ///
    /// Call from the `catch` of a load: `viewState.applyLoadFailure(error)`.
    mutating func applyLoadFailure(_ error: any Error) {
        if Task.isCancelled || error is CancellationError {
            if case .loading = self {
                self = .initial
            }
        } else {
            self = .error(ViewStateError(error))
        }
    }

}
