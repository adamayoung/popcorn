//
//  TVEpisodeCastAndCrewScreen.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import Presentation
import SwiftUI

/// The MVVM TV episode cast and crew screen, driven by
/// ``TVEpisodeCastAndCrewViewModel``.
///
/// Renders the same store-free ``TVEpisodeCastAndCrewContentView`` and reproduces
/// the exact loading / error chrome of the former `TVEpisodeCastAndCrewView`, so
/// recorded snapshots stay byte-identical.
public struct TVEpisodeCastAndCrewScreen: View {

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Namespace private var namespace
    @State private var viewModel: TVEpisodeCastAndCrewViewModel

    public init(viewModel: TVEpisodeCastAndCrewViewModel) {
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

extension TVEpisodeCastAndCrewScreen {

    private var loadingBody: some View {
        ProgressView()
            .accessibilityLabel(Text("LOADING", bundle: .module))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

}

extension TVEpisodeCastAndCrewScreen {

    private func content(_ snapshot: TVEpisodeCastAndCrewViewSnapshot) -> some View {
        TVEpisodeCastAndCrewContentView(
            castMembers: snapshot.castMembers,
            crewByDepartment: snapshot.crewByDepartment,
            transitionNamespace: namespace
        ) { personID, transitionID in
            viewModel.selectPerson(id: personID, transitionID: transitionID)
        }
    }

}

extension TVEpisodeCastAndCrewScreen {

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
            TVEpisodeCastAndCrewScreen(
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
            TVEpisodeCastAndCrewScreen(viewModel: .preview(viewState: .loading))
        }
    }

    #Preview("Error") {
        NavigationStack {
            TVEpisodeCastAndCrewScreen(
                viewModel: .preview(viewState: .error(ViewStateError(FetchCreditsError.notFound())))
            )
        }
    }
#endif
