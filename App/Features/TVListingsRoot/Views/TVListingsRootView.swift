//
//  TVListingsRootView.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import SwiftUI
import TVListingsFeature

/// The TV Listings tab root. Hosts the listings screen in a `NavigationStack`.
///
/// The TV Listings home is a flat list with no push navigation, modals, or
/// drill-down, so this is a bare `NavigationStack` with no router.
struct TVListingsRootView: View {

    let viewModel: TVListingsViewModel

    var body: some View {
        NavigationStack {
            TVListingsView(viewModel: viewModel)
        }
    }

}
