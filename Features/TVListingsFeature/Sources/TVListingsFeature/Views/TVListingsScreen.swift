//
//  TVListingsScreen.swift
//  TVListingsFeature
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import Presentation
import SwiftUI
import TVListingsDomain

/// The MVVM TV listings screen, driven by ``TVListingsViewModel``.
///
/// Reproduces the exact content / toolbar / loading / error chrome of the former
/// store-based `TVListingsView`. The view does **not** own the view model —
/// `AppRootView` owns it via `@State` — so it is stored as a plain `let`.
public struct TVListingsScreen: View {

    let viewModel: TVListingsViewModel

    public init(viewModel: TVListingsViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        content
            .overlay {
                if viewModel.viewState.isLoading {
                    ProgressView()
                        .accessibilityLabel(Text("TV_LISTINGS_LOADING", bundle: .module))
                }
            }
            .navigationTitle(Text("TV_LISTINGS_TITLE", bundle: .module))
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    syncButton
                }
            }
            .overlay(alignment: .bottom) {
                if let kind = viewModel.lastSyncErrorKind {
                    errorBanner(kind: kind)
                }
            }
            .accessibilityIdentifier("tvListings.view")
            .task(id: viewModel.reloadID) {
                await viewModel.load()
            }
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
            }

        case .error(let error):
            errorBody(error)

        default:
            Color.clear
        }
    }

    private var syncButton: some View {
        Button {
            Task { await viewModel.sync() }
        } label: {
            if viewModel.isSyncing {
                ProgressView()
                    .accessibilityLabel(Text("TV_LISTINGS_SYNCING", bundle: .module))
            } else {
                Label {
                    Text("TV_LISTINGS_SYNC_BUTTON", bundle: .module)
                } icon: {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
        .disabled(viewModel.isSyncing)
        .accessibilityIdentifier("tvListings.syncButton")
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
        } actions: {
            Button {
                Task { await viewModel.sync() }
            } label: {
                Text("TV_LISTINGS_SYNC_BUTTON", bundle: .module)
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.isSyncing)
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

    private func errorBanner(kind: TVListingsViewModel.ErrorKind) -> some View {
        Button {
            viewModel.dismissSyncError()
        } label: {
            Text(kind.localizedMessage)
                .font(.footnote)
                .foregroundStyle(.white)
                .padding(.spacing12)
                .frame(maxWidth: .infinity)
                .background(.red)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.spacing16)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text(kind.localizedMessage))
        .accessibilityHint(Text("TV_LISTINGS_SYNC_ERROR_DISMISS_HINT", bundle: .module))
        .accessibilityIdentifier("tvListings.syncError")
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

                Text(
                    String(
                        localized: "\(item.programme.startTime.formatted(Self.timeFormatStyle)) – \(item.programme.endTime.formatted(Self.timeFormatStyle))",
                        bundle: .module
                    )
                )
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, .spacing4)
        .accessibilityElement(children: .combine)
    }

}

private extension TVListingsViewModel.ErrorKind {

    var localizedMessage: LocalizedStringResource {
        switch self {
        case .network:
            LocalizedStringResource("TV_LISTINGS_SYNC_ERROR_NETWORK", bundle: .atURL(Bundle.module.bundleURL))

        case .local:
            LocalizedStringResource("TV_LISTINGS_SYNC_ERROR_LOCAL", bundle: .atURL(Bundle.module.bundleURL))

        case .unknown:
            LocalizedStringResource("TV_LISTINGS_SYNC_ERROR_UNKNOWN", bundle: .atURL(Bundle.module.bundleURL))
        }
    }

}

#if DEBUG
    #Preview("Ready") {
        NavigationStack {
            TVListingsScreen(
                viewModel: .preview(
                    viewState: .ready(
                        TVListingsViewSnapshot(items: [
                            TVListingsNowPlayingItem(
                                channel: TVChannel(
                                    id: "BBC_ONE",
                                    name: "BBC One",
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
            TVListingsScreen(viewModel: .preview(viewState: .ready(TVListingsViewSnapshot())))
        }
    }

    #Preview("Loading") {
        NavigationStack {
            TVListingsScreen(viewModel: .preview(viewState: .loading))
        }
    }

    #Preview("Error") {
        NavigationStack {
            TVListingsScreen(viewModel: .preview(viewState: .error(ViewStateError(message: "Something went wrong"))))
        }
    }
#endif
