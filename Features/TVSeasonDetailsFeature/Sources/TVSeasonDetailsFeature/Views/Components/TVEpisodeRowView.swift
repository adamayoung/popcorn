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

                if let airDate = episode.airDate {
                    airDateText(for: airDate)
                        .textCase(.uppercase)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .accessibilityLabel(
                            Text(
                                "AIR_DATE \(airDate.formatted(.dateTime.year().month(.wide).day()))",
                                bundle: .module
                            )
                        )
                }

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

    @ViewBuilder
    private func airDateText(for date: Date) -> some View {
        let calendar = Calendar.autoupdatingCurrent
        let startOfToday = calendar.startOfDay(for: .now)
        let startOfDate = calendar.startOfDay(for: date)
        let days = calendar.dateComponents(
            [.day], from: startOfToday, to: startOfDate
        ).day ?? 0

        if days > 0, days <= 7 {
            let weekday = date.formatted(
                Date.FormatStyle().weekday(.wide)
            )
            Text(
                "COMING_NEXT_WEEKDAY \(weekday)",
                bundle: .module
            )
        } else if days > 7 {
            let formatted = date.formatted(
                .dateTime.year().month(.wide).day()
            )
            Text("COMING_DATE \(formatted)", bundle: .module)
        } else {
            Text(
                date,
                format: .dateTime.year().month(.wide).day()
            )
        }
    }

}

#Preview {
    List {
        ForEach(TVEpisode.mocks) { episode in
            TVEpisodeRowView(episode: episode)
        }
    }
}
