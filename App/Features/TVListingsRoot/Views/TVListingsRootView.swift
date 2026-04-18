//
//  TVListingsRootView.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import SwiftUI
import TVListingsFeature

struct TVListingsRootView: View {

    @Bindable var store: StoreOf<TVListingsRootFeature>

    var body: some View {
        TVListingsView(
            store: store.scope(state: \.tvListings, action: \.tvListings)
        )
    }

}

#Preview {
    TVListingsRootView(
        store: Store(
            initialState: TVListingsRootFeature.State(),
            reducer: {
                TVListingsRootFeature()
            }
        )
    )
}
