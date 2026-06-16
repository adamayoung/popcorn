//
//  TVListingsView.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import Presentation
import SwiftUI
import TVListingsDomain

/// The TV listings screen, driven by ``TVListingsViewModel``.
///
/// The view owns its view model via `@State`, so it is self-contained and
/// behaves correctly regardless of how a host retains it.
public struct TVListingsView: View {

    /// Constrains the determinate sync bar so it doesn't stretch edge-to-edge on wide layouts.
    private static let syncingBarMaxWidth: CGFloat = 280

    @State private var viewModel: TVListingsViewModel

    public init(viewModel: TVListingsViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    public var body: some View {
        // Foreground refresh is driven by the host (AppRoot reloads this view when the
        // app-level sync completes), so the view itself doesn't observe `scenePhase` —
        // that avoided a double reload per foreground. Initial load is via `.task`, and
        // pull-to-refresh re-reads the cache on demand.
        content
            .overlay {
                if viewModel.shouldShowSyncProgress, let progress = viewModel.syncProgress {
                    syncingView(progress: progress)
                } else if viewModel.viewState.isLoading {
                    ProgressView()
                        .accessibilityLabel(Text("TV_LISTINGS_LOADING", bundle: .module))
                }
            }
            .navigationTitle(Text("TV_LISTINGS_TITLE", bundle: .module))
            .accessibilityIdentifier("tvListings.view")
            .toolbar {
                // Always declared (disabled until regions load) so the button doesn't pop in
                // and shift the layout on first launch.
                ToolbarItem(placement: toolbarTrailingPlacement) {
                    regionMenu
                        .disabled(viewModel.regionsByNation.isEmpty)
                }
            }
            .task(id: viewModel.reloadID) {
                await viewModel.load()
            }
    }

    private var regionMenu: some View {
        Menu {
            ForEach(viewModel.regionsByNation) { section in
                Menu(section.nation) {
                    ForEach(section.regions) { region in
                        Button {
                            viewModel.selectRegion(region)
                        } label: {
                            if region.id == viewModel.selectedRegion?.id {
                                Label(region.name, systemImage: "checkmark")
                            } else {
                                Text(region.name)
                            }
                        }
                    }
                }
            }
        } label: {
            Label {
                Text("TV_LISTINGS_REGION", bundle: .module)
            } icon: {
                Image(systemName: "line.3.horizontal.decrease.circle")
            }
        }
        .accessibilityIdentifier("tvListings.region-filter")
    }

    private var toolbarTrailingPlacement: ToolbarItemPlacement {
        #if os(macOS)
            .automatic
        #else
            .primaryAction
        #endif
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.viewState {
        case .ready(let snapshot):
            if snapshot.items.isEmpty {
                emptyBody
            } else {
                List(snapshot.items) { item in
                    NowPlayingRow(item: item)
                }
                .listStyle(.plain)
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

    /// The determinate EPG-sync progress bar shown on first launch, replacing the
    /// indeterminate loading spinner until today's listings are cached.
    ///
    /// A labelled `ProgressView(value:)` renders the "Syncing TV Listings" label above the
    /// linear bar and, unlike a separate `Text` + `.combine`, lets the bar announce its own
    /// percentage value to VoiceOver ("Syncing TV Listings, N percent").
    private func syncingView(progress: Float) -> some View {
        ProgressView(value: Double(progress)) {
            Text("TV_LISTINGS_SYNCING", bundle: .module)
                .font(.headline)
        }
        .progressViewStyle(.linear)
        .frame(maxWidth: Self.syncingBarMaxWidth)
        .padding()
        .accessibilityIdentifier("tvListings.sync-progress")
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

private struct NowPlayingRow: View {

    private static let timeFormatStyle = Date.FormatStyle.dateTime.hour().minute()
    /// Square logo size that satisfies the iOS 44pt minimum tap target.
    private static let logoSize: CGFloat = 44

    let item: TVListingsNowPlayingItem

    var body: some View {
        HStack(spacing: .spacing12) {
            LogoImage(url: item.channel.logoURL)
                .frame(width: Self.logoSize, height: Self.logoSize)

            VStack(alignment: .leading, spacing: .spacing4) {
                Text(item.channel.name)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(item.programme.title)
                    .font(.body)
                    .fontWeight(.semibold)

                Text(Self.timeRange(for: item.programme))
                    .font(.caption)
                    .foregroundStyle(.secondary)

                if let nextProgramme = item.nextProgramme {
                    VStack(alignment: .leading, spacing: .spacing2) {
                        Text(nextProgramme.title)
                            // Smaller than the current programme's title but still bold.
                                .font(.subheadline)
                                .fontWeight(.semibold)

                        Text(Self.timeRange(for: nextProgramme))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, .spacing4)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, .spacing4)
        .accessibilityElement(children: .combine)
    }

    private static func timeRange(for programme: TVProgramme) -> String {
        String(
            localized: "\(programme.startTime.formatted(timeFormatStyle)) – \(programme.endTime.formatted(timeFormatStyle))",
            bundle: .module
        )
    }

}

#if DEBUG
    #Preview("Ready") {
        NavigationStack {
            TVListingsView(
                viewModel: .preview(
                    viewState: .ready(
                        TVListingsViewSnapshot(items: [
                            TVListingsNowPlayingItem(
                                channel: Channel(
                                    id: "BBC_ONE",
                                    name: "BBC One",
                                    type: .television,
                                    isHD: true,
                                    logoURL: nil,
                                    channelNumbers: []
                                ),
                                programme: TVProgramme(
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
                                ),
                                nextProgramme: TVProgramme(
                                    id: "BBC_ONE:2",
                                    channelID: "BBC_ONE",
                                    title: "The Weather",
                                    description: "The forecast for the week ahead.",
                                    startTime: Date(timeIntervalSince1970: 1900),
                                    endTime: Date(timeIntervalSince1970: 2200),
                                    duration: 300,
                                    episodeNumber: nil,
                                    seasonNumber: nil,
                                    imageURL: nil,
                                    tmdbTVSeriesID: nil,
                                    tmdbMovieID: nil
                                )
                            )
                        ])
                    )
                )
            )
        }
    }

    #Preview("Empty") {
        NavigationStack {
            TVListingsView(viewModel: .preview(viewState: .ready(TVListingsViewSnapshot())))
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

    #Preview("Syncing") {
        NavigationStack {
            TVListingsView(
                viewModel: .preview(viewState: .ready(TVListingsViewSnapshot()), syncProgress: 0.4)
            )
        }
    }
#endif
