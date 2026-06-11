//
//  TVListingsView.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Presentation
import SwiftUI
import TVListingsDomain

/// The TV listings screen, driven by ``TVListingsViewModel``.
///
/// The view owns its view model via `@State`, so it is self-contained and
/// behaves correctly regardless of how a host retains it.
public struct TVListingsView: View {

    @State private var viewModel: TVListingsViewModel

    /// Disables the one-shot auto-scroll to "now" so snapshot tests render the
    /// deterministic unscrolled frame.
    private let disableAutoScroll: Bool

    public init(viewModel: TVListingsViewModel, disableAutoScroll: Bool = false) {
        _viewModel = State(initialValue: viewModel)
        self.disableAutoScroll = disableAutoScroll
    }

    public var body: some View {
        // Foreground refresh is driven by the host (AppRoot reloads this view when the
        // app-level sync completes), so the view itself doesn't observe `scenePhase` —
        // that avoided a double reload per foreground. Initial load is via `.task`, and
        // pull-to-refresh re-reads the cache on demand.
        content
            .overlay {
                if viewModel.viewState.isLoading {
                    ProgressView()
                        .accessibilityLabel(Text("TV_LISTINGS_LOADING", bundle: .module))
                }
            }
            .navigationTitle(Text("TV_LISTINGS_TITLE", bundle: .module))
            .accessibilityIdentifier("tvListings.view")
            .task(id: viewModel.reloadID) {
                await viewModel.load()
            }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.viewState {
        case .ready(let snapshot):
            if snapshot.rows.isEmpty {
                emptyBody
            } else {
                EPGGrid(snapshot: snapshot, disableAutoScroll: disableAutoScroll)
                    .refreshable {
                        await viewModel.refresh()
                    }
            }

        case .error(let error):
            errorBody(error)

        default:
            Color.clear
        }
    }

    private var emptyBody: some View {
        ContentUnavailableView {
            Label {
                Text("TV_LISTINGS_EMPTY_TITLE", bundle: .module)
            } icon: {
                Image(systemName: "tv")
            }
        } description: {
            Text("TV_LISTINGS_EMPTY_DESCRIPTION", bundle: .module)
        }
    }

    private func errorBody(_ error: ViewStateError) -> some View {
        ContentUnavailableView {
            Label {
                Text("TV_LISTINGS_LOAD_ERROR_TITLE", bundle: .module)
            } icon: {
                Image(systemName: "exclamationmark.triangle")
            }
        } description: {
            Text(error.message)
        } actions: {
            Button {
                viewModel.reload()
            } label: {
                Text("TV_LISTINGS_RETRY", bundle: .module)
            }
            .buttonStyle(.borderedProminent)
        }
    }

}

#if DEBUG
    #Preview("Ready") {
        let channel = TVChannel(
            id: "BBC_ONE",
            name: "BBC One",
            isHD: true,
            logoURL: nil,
            channelNumbers: []
        )
        let programme = TVProgramme(
            id: "BBC_ONE:1",
            channelID: "BBC_ONE",
            title: "News at Ten",
            description: "The latest headlines.",
            startTime: Date(timeIntervalSince1970: 1000),
            endTime: Date(timeIntervalSince1970: 1900),
            duration: 900,
            episodeNumber: nil,
            seasonNumber: nil,
            imageURL: nil,
            tmdbTVSeriesID: nil,
            tmdbMovieID: nil
        )
        let now = Date(timeIntervalSince1970: 1500)

        return NavigationStack {
            TVListingsView(
                viewModel: .preview(
                    viewState: .ready(
                        TVListingsGridSnapshot(
                            rows: [
                                TVListingsChannelRow(
                                    channel: channel,
                                    programmes: [
                                        TVListingsProgrammeItem(
                                            programme: programme,
                                            isAiringNow: true,
                                            genre: nil,
                                            progress: 0.5
                                        )
                                    ]
                                )
                            ],
                            geometry: .flooringNow(now),
                            now: now
                        )
                    )
                )
            )
        }
    }

    #Preview("Empty") {
        let now = Date(timeIntervalSince1970: 1500)
        return NavigationStack {
            TVListingsView(
                viewModel: .preview(
                    viewState: .ready(
                        TVListingsGridSnapshot(rows: [], geometry: .flooringNow(now), now: now)
                    )
                )
            )
        }
    }

    #Preview("Loading") {
        NavigationStack {
            TVListingsView(viewModel: .preview(viewState: .loading))
        }
    }

    #Preview("Error") {
        NavigationStack {
            TVListingsView(viewModel: .preview(viewState: .error(ViewStateError(message: "Something went wrong"))))
        }
    }
#endif
