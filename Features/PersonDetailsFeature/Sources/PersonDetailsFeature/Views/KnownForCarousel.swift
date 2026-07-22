//
//  KnownForCarousel.swift
//  PersonDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import SwiftUI

struct KnownForCarousel: View {

    var items: [KnownForItem]
    var didSelectItem: (_ item: KnownForItem) -> Void

    var body: some View {
        Carousel {
            // Key on the offset, not the item id: a movie and a TV series can share
            // the same TMDb id, so the id alone is not a unique identity here.
            ForEach(items.enumerated(), id: \.offset) { offset, item in
                Button {
                    didSelectItem(item)
                } label: {
                    BackdropCarouselCell(
                        imageURL: item.backdropURL,
                        logoURL: item.logoURL
                    ) {
                        EmptyView()
                    }
                }
                .accessibilityIdentifier("person-details.known-for.item.\(offset)")
                .accessibilityLabel(Text(verbatim: item.title))
                .accessibilityHint(hint(for: item))
                .buttonStyle(.plain)
                .fixedSize(horizontal: true, vertical: false)
            }
        }
        .accessibilityIdentifier("person-details.known-for.carousel")
        .contentMargins([.leading, .trailing], .spacing16)
    }

    private func hint(for item: KnownForItem) -> Text {
        switch item.mediaType {
        case .movie:
            Text("VIEW_MOVIE_DETAILS_HINT", bundle: .module)
        case .tvSeries:
            Text("VIEW_TV_SERIES_DETAILS_HINT", bundle: .module)
        }
    }

}

#Preview {
    ScrollView {
        KnownForCarousel(
            items: KnownForItem.mocks,
            didSelectItem: { _ in }
        )
    }
}
