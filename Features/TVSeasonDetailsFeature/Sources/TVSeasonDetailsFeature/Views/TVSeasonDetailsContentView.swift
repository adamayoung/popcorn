//
//  TVSeasonDetailsContentView.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import SwiftUI

struct TVSeasonDetailsContentView: View {

    var overview: String?
    var episodes: [TVEpisode]
    var didSelectEpisode: (_ episodeNumber: Int) -> Void

    var body: some View {
        List {
            if let overview, !overview.isEmpty {
                Section {
                    Text(verbatim: overview)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .accessibilityIdentifier("tv-season-details.overview.section")
            }

            Section {
                ForEach(episodes) { episode in
                    Button {
                        didSelectEpisode(episode.episodeNumber)
                    } label: {
                        TVEpisodeRowView(episode: episode)
                    }
                    .accessibilityHint(Text("VIEW_EPISODE_DETAILS_HINT", bundle: .module))
                    .accessibilityIdentifier("tv-season-details.episodes.episode.\(episode.episodeNumber)")
                    .buttonStyle(.plain)
                }
            } header: {
                Text("EPISODES_SECTION_HEADER", bundle: .module)
            }
            .accessibilityIdentifier("tv-season-details.episodes.section")
        }
        #if os(iOS)
        .listStyle(.insetGrouped)
        #endif
        .accessibilityIdentifier("tv-season-details.view")
    }

}

#Preview {
    NavigationStack {
        TVSeasonDetailsContentView(
            overview: "The first season of Breaking Bad.",
            episodes: TVEpisode.mocks,
            didSelectEpisode: { _ in }
        )
        .navigationTitle("Season 1")
    }
}

#Preview("No Overview") {
    NavigationStack {
        TVSeasonDetailsContentView(
            overview: nil,
            episodes: TVEpisode.mocks,
            didSelectEpisode: { _ in }
        )
        .navigationTitle("Season 1")
    }
}
