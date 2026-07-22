//
//  CreditRow.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import SwiftUI

struct CreditRow: View {

    let item: CreditItem

    var body: some View {
        HStack(spacing: .spacing12) {
            PosterImage(url: item.posterURL)
                .posterWidth(80)
                .clipShape(.rect(cornerRadius: 10))

            VStack(alignment: .leading, spacing: .spacing2) {
                Text(verbatim: item.title)
                    .font(.headline)

                if let partsText = item.partsText {
                    Text(verbatim: partsText)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                if let date = item.date {
                    Text(date, format: .dateTime.year())
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()
        }
        .accessibilityElement(children: .combine)
        .contentShape(Rectangle())
    }

}

#if DEBUG
    #Preview {
        List {
            ForEach(CreditItem.mocks) { item in
                CreditRow(item: item)
            }
        }
    }
#endif
