//
//  TVListingsView.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI
import TCAFoundation

public struct TVListingsView: View {

    @Bindable var store: StoreOf<TVListingsFeature>

    public init(store: StoreOf<TVListingsFeature>) {
        self.store = store
    }

    public var body: some View {
        content
            .overlay {
                if store.viewState.isLoading {
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
                if let kind = store.lastSyncErrorKind {
                    errorBanner(kind: kind)
                }
            }
            .accessibilityIdentifier("tvListings.view")
            .task { store.send(.didAppear) }
    }

    @ViewBuilder
    private var content: some View {
        switch store.viewState {
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
            store.send(.syncTapped)
        } label: {
            if store.isSyncing {
                ProgressView()
            } else {
                Label {
                    Text("TV_LISTINGS_SYNC_BUTTON", bundle: .module)
                } icon: {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
        .disabled(store.isSyncing)
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
                store.send(.syncTapped)
            } label: {
                Text("TV_LISTINGS_SYNC_BUTTON", bundle: .module)
            }
            .buttonStyle(.borderedProminent)
            .disabled(store.isSyncing)
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
                store.send(.fetch)
            } label: {
                Text("TV_LISTINGS_RETRY", bundle: .module)
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private func errorBanner(kind: TVListingsFeature.ErrorKind) -> some View {
        Text(kind.localizedMessage)
            .font(.footnote)
            .foregroundStyle(.white)
            .padding(.spacing12)
            .frame(maxWidth: .infinity)
            .background(.red)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.spacing16)
            .accessibilityAddTraits(.isStaticText)
            .accessibilityIdentifier("tvListings.syncError")
    }

}

private struct NowPlayingRow: View {

    private static let timeFormatStyle = Date.FormatStyle.dateTime.hour().minute()

    let item: TVListingsFeature.NowPlayingItem

    var body: some View {
        HStack(spacing: .spacing12) {
            LogoImage(url: item.channel.logoURL)
                .frame(width: 44, height: 44)

            VStack(alignment: .leading, spacing: .spacing4) {
                Text(item.channel.name)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(item.programme.title)
                    .font(.body)
                    .fontWeight(.semibold)

                Text(
                    "\(item.programme.startTime.formatted(Self.timeFormatStyle)) – \(item.programme.endTime.formatted(Self.timeFormatStyle))"
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

private extension TVListingsFeature.ErrorKind {

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

#Preview {
    TVListingsView(
        store: Store(
            initialState: TVListingsFeature.State(),
            reducer: {
                TVListingsFeature()
            }
        )
    )
}
