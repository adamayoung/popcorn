//
//  TVSeasonDetailsContentView.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import SwiftUI

struct TVSeasonDetailsContentView: View {

    var season: TVSeason
    var episodes: [TVEpisode]
    var didSelectEpisode: (_ episodeNumber: Int) -> Void

    var body: some View {
        List {
            if let overview = season.overview, !overview.isEmpty {
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
        .navigationBarTitleDisplayMode(.large)
        #endif
        .navigationTitle(Text(verbatim: season.name))
        #if !os(visionOS)
            .navigationSubtitle(Text(verbatim: season.tvSeriesName))
        #endif
            .accessibilityIdentifier("tv-season-details.view")
    }

}

#Preview {
    NavigationStack {
        TVSeasonDetailsContentView(
            season: TVSeason.mock,
            episodes: TVEpisode.mocks,
            didSelectEpisode: { _ in }
        )
        .navigationTitle("Season 1")
    }
}

#Preview("No Overview") {
    NavigationStack {
        TVSeasonDetailsContentView(
            season: TVSeason.mock,
            episodes: TVEpisode.mocks,
            didSelectEpisode: { _ in }
        )
        .navigationTitle("Season 1")
    }
}
