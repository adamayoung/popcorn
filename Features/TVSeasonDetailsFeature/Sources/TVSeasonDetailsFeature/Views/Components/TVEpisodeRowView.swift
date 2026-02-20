//
//  TVEpisodeRowView.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import SwiftUI

struct TVEpisodeRowView: View {

    @ScaledMetric(relativeTo: .headline)
    private var stillHeight: CGFloat = 80

    let episode: TVEpisode

    var body: some View {
        HStack(spacing: 12) {
            StillImage(url: episode.stillURL)
                .stillHeight(stillHeight)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                }

            VStack(alignment: .leading, spacing: 2) {
                Text(
                    "EPISODE_TITLE \(episode.episodeNumber) \(episode.name)",
                    bundle: .module
                )
                .font(.headline)
                .lineLimit(2)

                if let overview = episode.overview {
                    Text(verbatim: overview)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }

            Spacer(minLength: 0)
        }
        .accessibilityElement(children: .combine)
        .contentShape(Rectangle())
    }

}

#Preview {
    List {
        ForEach(TVEpisode.mocks) { episode in
            TVEpisodeRowView(episode: episode)
        }
    }
}
