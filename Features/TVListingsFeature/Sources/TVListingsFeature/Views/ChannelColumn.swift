//
//  ChannelColumn.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import SwiftUI
import TVListingsDomain

/// The fixed left-hand column of channel cells. Lazily renders one cell per row,
/// at the shared ``EPGMetrics/rowHeight`` so it stays aligned with the body rows.
struct ChannelColumn: View {

    let rows: [TVListingsChannelRow]

    var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(rows) { row in
                ChannelCell(channel: row.channel)
                    .frame(height: EPGMetrics.rowHeight)
            }
        }
        .frame(width: EPGMetrics.channelColumnWidth)
    }

}

/// A single channel cell: logo (or an initials fallback when there is no logo
/// URL) above the channel number.
struct ChannelCell: View {

    let channel: TVChannel

    private var channelNumber: String? {
        channel.channelNumbers.first?.channelNumber
    }

    var body: some View {
        VStack(spacing: .spacing4) {
            logo
                .frame(width: 44, height: 32)

            if let channelNumber {
                Text(channelNumber)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, .spacing4)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabel)
    }

    @ViewBuilder
    private var logo: some View {
        if let logoURL = channel.logoURL {
            LogoImage(url: logoURL)
        } else {
            ChannelInitials(name: channel.name)
        }
    }

    private var accessibilityLabel: Text {
        if let channelNumber {
            Text(
                "\(channel.name), \(String(localized: "CHANNEL_NUMBER_LABEL", defaultValue: "channel \(channelNumber)", bundle: .module))"
            )
        } else {
            Text(channel.name)
        }
    }

}

/// An initials badge shown when a channel has no logo image, so the cell never
/// shows an empty space (and so snapshots stay deterministic with no async load).
struct ChannelInitials: View {

    let name: String

    var body: some View {
        RoundedRectangle(cornerRadius: .spacing6)
            .fill(Color.secondary.opacity(0.15))
            .overlay {
                Text(EPGLayout.channelInitials(for: name))
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                    .padding(.spacing2)
            }
            .accessibilityHidden(true)
    }

}
