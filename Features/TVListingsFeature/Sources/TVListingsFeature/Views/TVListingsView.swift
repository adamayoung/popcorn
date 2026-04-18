//
//  TVListingsView.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import SwiftUI

public struct TVListingsView: View {

    @Bindable var store: StoreOf<TVListingsFeature>

    public init(store: StoreOf<TVListingsFeature>) {
        self.store = store
    }

    public var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Spacer()

                Button {
                    store.send(.syncTapped)
                } label: {
                    if store.isSyncing {
                        HStack(spacing: 8) {
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

                if let error = store.lastSyncError {
                    Text(error)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .accessibilityIdentifier("tvListings.syncError")
                }

                Spacer()
            }
            .padding()
            .navigationTitle(Text("TV_LISTINGS_TITLE", bundle: .module))
        }
        .accessibilityIdentifier("tvListings.view")
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
