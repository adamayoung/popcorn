//
//  MovieCastAndCrewScreen.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import Presentation
import SwiftUI

/// The MVVM movie cast and crew screen, driven by ``MovieCastAndCrewViewModel``.
///
/// Renders the same store-free ``MovieCastAndCrewContentView`` and reproduces the
/// exact loading / error chrome of the former `MovieCastAndCrewView`, so recorded
/// snapshots stay byte-identical.
public struct MovieCastAndCrewScreen: View {

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

extension MovieCastAndCrewScreen {

    private var loadingBody: some View {
        ProgressView()
            .accessibilityLabel(Text("LOADING", bundle: .module))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

}

extension MovieCastAndCrewScreen {

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

extension MovieCastAndCrewScreen {

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
            MovieCastAndCrewScreen(
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
            MovieCastAndCrewScreen(viewModel: .preview(viewState: .loading))
        }
    }

    #Preview("Error") {
        NavigationStack {
            MovieCastAndCrewScreen(
                viewModel: .preview(viewState: .error(ViewStateError(FetchCreditsError.notFound())))
            )
        }
    }
#endif
