//
//  TVEpisodeDetailsView.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import Presentation
import SwiftUI

/// The TV episode details view, driven by ``TVEpisodeDetailsViewModel``.
///
/// Renders ``TVEpisodeDetailsContentView`` with loading and error chrome.
public struct TVEpisodeDetailsView: View {

    @State private var viewModel: TVEpisodeDetailsViewModel

    public init(viewModel: TVEpisodeDetailsViewModel) {
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

extension TVEpisodeDetailsView {

    private var loadingBody: some View {
        ProgressView()
            .accessibilityLabel(Text("LOADING", bundle: .module))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

}

extension TVEpisodeDetailsView {

    private func content(_ snapshot: TVEpisodeDetailsViewSnapshot) -> some View {
        TVEpisodeDetailsContentView(
            episode: snapshot.episode,
            castMembers: snapshot.castMembers,
            crewMembers: snapshot.crewMembers,
            didSelectCastAndCrew: {
                viewModel.openCastAndCrew()
            },
            didSelectPerson: { personID in
                viewModel.selectPerson(id: personID)
            }
        )
    }

}

extension TVEpisodeDetailsView {

    private func errorBody(_ error: ViewStateError) -> some View {
        ContentLoadErrorView(
            message: error.message,
            systemImage: "tv",
            reason: error.reason,
            isRetryable: error.isRetryable,
            retryAction: { viewModel.reload() }
        )
    }

}

#if DEBUG
    #Preview("Ready") {
        NavigationStack {
            TVEpisodeDetailsView(
                viewModel: .preview(
                    viewState: .ready(
                        .init(
                            episode: TVEpisode.mock,
                            castMembers: CastMember.mocks,
                            crewMembers: CrewMember.mocks
                        )
                    )
                )
            )
        }
    }

    #Preview("Loading") {
        NavigationStack {
            TVEpisodeDetailsView(viewModel: .preview(viewState: .loading))
        }
    }

    #Preview("Error") {
        NavigationStack {
            TVEpisodeDetailsView(
                viewModel: .preview(viewState: .error(ViewStateError(FetchEpisodeDetailsError.notFound())))
            )
        }
    }
#endif
