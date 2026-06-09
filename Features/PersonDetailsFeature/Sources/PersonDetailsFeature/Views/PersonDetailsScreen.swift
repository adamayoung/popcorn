//
//  PersonDetailsScreen.swift
//  PersonDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import Presentation
import SwiftUI

/// The MVVM person details screen, driven by ``PersonDetailsViewModel``.
///
/// Renders the same store-free ``PersonDetailsContentView`` and reproduces the
/// exact loading / error chrome of the former `PersonDetailsView`, so recorded
/// snapshots stay byte-identical.
public struct PersonDetailsScreen: View {

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var viewModel: PersonDetailsViewModel

    public init(viewModel: PersonDetailsViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    public var body: some View {
        ZStack {
            switch viewModel.viewState {
            case .ready(let snapshot):
                content(person: snapshot.person)
            case .error(let error):
                errorBody(error)
            default:
                EmptyView()
            }
        }
        .accessibilityIdentifier("person-details.view")
        .contentTransition(.opacity)
        .animation(
            reduceMotion ? nil : .easeInOut(duration: 1),
            value: viewModel.viewState.isReady
        )
        .animation(
            reduceMotion ? nil : .easeInOut(duration: 1),
            value: viewModel.viewState.isError
        )
        .overlay {
            if viewModel.viewState.isLoading {
                loadingBody
            }
        }
        .onAppear {
            viewModel.didAppear()
        }
        .task(id: viewModel.reloadID) {
            await viewModel.load()
        }
    }

}

extension PersonDetailsScreen {

    private var loadingBody: some View {
        ProgressView()
            .accessibilityLabel(Text("LOADING", bundle: .module))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

}

extension PersonDetailsScreen {

    private func content(person: Person) -> some View {
        PersonDetailsContentView(
            person: person,
            isFocalPointEnabled: viewModel.isFocalPointEnabled
        )
    }

}

extension PersonDetailsScreen {

    private func errorBody(_ error: ViewStateError) -> some View {
        ContentLoadErrorView(
            message: error.message,
            systemImage: "person",
            reason: error.reason,
            isRetryable: error.isRetryable,
            retryAction: { viewModel.reload() }
        )
    }

}

#if DEBUG
    #Preview("Ready") {
        NavigationStack {
            PersonDetailsScreen(
                viewModel: .preview(viewState: .ready(.init(person: Person.mock)))
            )
        }
    }

    #Preview("Loading") {
        NavigationStack {
            PersonDetailsScreen(viewModel: .preview(viewState: .loading))
        }
    }

    #Preview("Error") {
        NavigationStack {
            PersonDetailsScreen(
                viewModel: .preview(viewState: .error(ViewStateError(FetchPersonError.notFound())))
            )
        }
    }
#endif
