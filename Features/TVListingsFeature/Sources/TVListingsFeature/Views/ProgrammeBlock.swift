//
//  ProgrammeBlock.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import SwiftUI
import TVListingsDomain

/// A single programme card in the EPG grid. Non-interactive (`allowsHitTesting`
/// false). Below ``EPGLayout/narrowBlockThreshold`` it collapses to a title-only
/// compact form (keeping the progress bar) so narrow blocks stay legible.
struct ProgrammeBlock: View {

    let item: TVListingsProgrammeItem
    let geometry: TimelineGeometry
    let width: CGFloat

    private var isNarrow: Bool {
        EPGLayout.isNarrow(width: width)
    }

    private var startTimeLabel: String {
        TimeHeader.label(for: item.programme.startTime, timeZone: geometry.timeZone)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: .spacing2) {
            Text(item.programme.title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.primary)
                .lineLimit(isNarrow ? 1 : 2)
                .truncationMode(.tail)

            if !isNarrow {
                HStack(spacing: .spacing4) {
                    Text(startTimeLabel)
                        .font(.caption2)
                        .foregroundStyle(.secondary)

                    if let genre = item.genre {
                        Text(genre)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }

                if item.isAiringNow {
                    Text("NOW", bundle: .module)
                        .font(.caption2.weight(.bold))
                        .foregroundStyle(Color.accentColor)
                }
            }

            Spacer(minLength: 0)

            if item.isAiringNow {
                ProgressView(value: item.progress)
                    .progressViewStyle(.linear)
                    .tint(Color.accentColor)
                    .scaleEffect(x: 1, y: 0.5, anchor: .bottom)
            }
        }
        .padding(.spacing6)
        .frame(width: width, height: EPGMetrics.rowHeight, alignment: .topLeading)
        .background(Color.secondary.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: .spacing10))
        .overlay {
            RoundedRectangle(cornerRadius: .spacing10)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        }
        .allowsHitTesting(false)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabel)
    }

    private var accessibilityLabel: Text {
        let endTimeLabel = TimeHeader.label(for: item.programme.endTime, timeZone: geometry.timeZone)
        let timeRange = String(
            localized: "\(startTimeLabel) – \(endTimeLabel)",
            bundle: .module
        )
        if item.isAiringNow {
            return Text(
                "\(item.programme.title), \(timeRange), \(String(localized: "PROGRAMME_NOW_PLAYING", defaultValue: "Now playing", bundle: .module))"
            )
        }
        return Text("\(item.programme.title), \(timeRange)")
    }

}
