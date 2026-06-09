//
//  TVEpisodeDetailsScreen.swift
//  TVEpisodeDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import Presentation
import SwiftUI

/// The MVVM TV episode details screen, driven by ``TVEpisodeDetailsViewModel``.
///
/// Renders the same store-free ``TVEpisodeDetailsContentView`` and reproduces the
/// exact loading / error chrome of the former `TVEpisodeDetailsView`, so recorded
/// snapshots stay byte-identical.
public struct TVEpisodeDetailsScreen: View {

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

extension TVEpisodeDetailsScreen {

    private var loadingBody: some View {
        ProgressView()
            .accessibilityLabel(Text("LOADING", bundle: .module))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

}

extension TVEpisodeDetailsScreen {

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

extension TVEpisodeDetailsScreen {

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
            TVEpisodeDetailsScreen(
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
            TVEpisodeDetailsScreen(viewModel: .preview(viewState: .loading))
        }
    }

    #Preview("Error") {
        NavigationStack {
            TVEpisodeDetailsScreen(
                viewModel: .preview(viewState: .error(ViewStateError(FetchEpisodeDetailsError.notFound())))
            )
        }
    }
#endif
