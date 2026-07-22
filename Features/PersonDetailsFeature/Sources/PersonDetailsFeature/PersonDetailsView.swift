//
//  PersonDetailsView.swift
//  PersonDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import Presentation
import SwiftUI

/// The person details screen, driven by ``PersonDetailsViewModel``.
///
/// Renders ``PersonDetailsContentView`` along with its loading / error chrome.
public struct PersonDetailsView: View {

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

extension PersonDetailsView {

    private var loadingBody: some View {
        ProgressView()
            .accessibilityLabel(Text("LOADING", bundle: .module))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

}

extension PersonDetailsView {

    private func content(person: Person) -> some View {
        PersonDetailsContentView(
            person: person,
            knownForState: viewModel.knownForState,
            isFocalPointEnabled: viewModel.isFocalPointEnabled,
            didSelectKnownForItem: { viewModel.selectKnownForItem($0) }
        )
    }

}

extension PersonDetailsView {

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
            PersonDetailsView(
                viewModel: .preview(
                    viewState: .ready(.init(person: Person.mock)),
                    knownForState: .ready(KnownForItem.mocks)
                )
            )
        }
    }

    #Preview("Loading") {
        NavigationStack {
            PersonDetailsView(viewModel: .preview(viewState: .loading))
        }
    }

    #Preview("Error") {
        NavigationStack {
            PersonDetailsView(
                viewModel: .preview(viewState: .error(ViewStateError(FetchPersonError.notFound())))
            )
        }
    }
#endif
