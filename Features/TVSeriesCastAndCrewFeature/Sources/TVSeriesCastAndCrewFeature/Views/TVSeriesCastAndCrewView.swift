//
//  TVSeriesCastAndCrewView.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import Presentation
import SwiftUI

/// The TV series cast and crew view, driven by ``TVSeriesCastAndCrewViewModel``.
///
/// Renders ``TVSeriesCastAndCrewContentView`` with loading and error chrome.
public struct TVSeriesCastAndCrewView: View {

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Namespace private var namespace
    @State private var viewModel: TVSeriesCastAndCrewViewModel

    public init(viewModel: TVSeriesCastAndCrewViewModel) {
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

extension TVSeriesCastAndCrewView {

    private var loadingBody: some View {
        ProgressView()
            .accessibilityLabel(Text("LOADING", bundle: .module))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

}

extension TVSeriesCastAndCrewView {

    private func content(_ snapshot: TVSeriesCastAndCrewViewSnapshot) -> some View {
        TVSeriesCastAndCrewContentView(
            castMembers: snapshot.castMembers,
            crewByDepartment: snapshot.crewByDepartment,
            transitionNamespace: namespace
        ) { personID, transitionID in
            viewModel.selectPerson(id: personID, transitionID: transitionID)
        }
    }

}

extension TVSeriesCastAndCrewView {

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
            TVSeriesCastAndCrewView(
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
            TVSeriesCastAndCrewView(viewModel: .preview(viewState: .loading))
        }
    }

    #Preview("Error") {
        NavigationStack {
            TVSeriesCastAndCrewView(
                viewModel: .preview(viewState: .error(ViewStateError(FetchCreditsError.notFound())))
            )
        }
    }
#endif
