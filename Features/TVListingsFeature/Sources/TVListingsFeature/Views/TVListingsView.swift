//
//  TVListingsView.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct TVListingsView: View {

    @Bindable var store: StoreOf<TVListingsFeature>

    public init(store: StoreOf<TVListingsFeature>) {
        self.store = store
    }

    public var body: some View {
        VStack(spacing: .spacing16) {
            Spacer()

            Button {
                store.send(.syncTapped)
            } label: {
                if store.isSyncing {
                    HStack(spacing: .spacing8) {
                        ProgressView()
                        Text("TV_LISTINGS_SYNCING", bundle: .module)
                    }
                } else {
                    Text("TV_LISTINGS_SYNC_BUTTON", bundle: .module)
                }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(store.isSyncing)
            .accessibilityIdentifier("tvListings.syncButton")

            if let kind = store.lastSyncErrorKind {
                Text(kind.localizedMessage)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .accessibilityAddTraits(.isStaticText)
                    .accessibilityIdentifier("tvListings.syncError")
            }

            Spacer()
        }
        .padding()
        .navigationTitle(Text("TV_LISTINGS_TITLE", bundle: .module))
        .accessibilityIdentifier("tvListings.view")
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
