//
//  MovieCastAndCrewView.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import Presentation
import SwiftUI

/// The movie cast and crew view, driven by ``MovieCastAndCrewViewModel``.
///
/// Renders the store-free ``MovieCastAndCrewContentView`` along with its loading /
/// error chrome.
public struct MovieCastAndCrewView: View {

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Namespace private var namespace
    @State private var viewModel: MovieCastAndCrewViewModel

    public init(viewModel: MovieCastAndCrewViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    public var body: some View {
        ZStack {
            switch viewModel.viewState {
            case .ready(let snapshot):
                content(snapshot)
            case .error(let error):
                errorBody(error)
            default:
                EmptyView()
            }
        }
        .contentTransition(.opacity)
        .animation(reduceMotion ? nil : .easeInOut(duration: 1), value: viewModel.viewState.isReady)
        .overlay {
            if viewModel.viewState.isLoading {
                loadingBody
            }
        }
        .task(id: viewModel.reloadID) {
            await viewModel.load()
        }
    }

}

extension MovieCastAndCrewView {

    private var loadingBody: some View {
        ProgressView()
            .accessibilityLabel(Text("LOADING", bundle: .module))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

}

extension MovieCastAndCrewView {

    private func content(_ snapshot: MovieCastAndCrewViewSnapshot) -> some View {
        MovieCastAndCrewContentView(
            castMembers: snapshot.castMembers,
            crewByDepartment: snapshot.crewByDepartment,
            transitionNamespace: namespace
        ) { personID, transitionID in
            viewModel.selectPerson(id: personID, transitionID: transitionID)
        }
    }

}

extension MovieCastAndCrewView {

    private func errorBody(_ error: ViewStateError) -> some View {
        ContentLoadErrorView(
            message: error.message,
            systemImage: "person.2",
            reason: error.reason,
            isRetryable: error.isRetryable,
            retryAction: { viewModel.reload() }
        )
    }

}

#if DEBUG
    #Preview("Ready") {
        NavigationStack {
            MovieCastAndCrewView(
                viewModel: .preview(
                    viewState: .ready(
                        .init(
                            castMembers: CastMember.mocks,
                            crewByDepartment: CrewDepartment.mocks
                        )
                    )
                )
            )
        }
    }

    #Preview("Loading") {
        NavigationStack {
            MovieCastAndCrewView(viewModel: .preview(viewState: .loading))
        }
    }

    #Preview("Error") {
        NavigationStack {
            MovieCastAndCrewView(
                viewModel: .preview(viewState: .error(ViewStateError(FetchCreditsError.notFound())))
            )
        }
    }
#endif
