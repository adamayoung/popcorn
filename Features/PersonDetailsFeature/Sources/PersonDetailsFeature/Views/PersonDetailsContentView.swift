//
//  PersonDetailsContentView.swift
//  PersonDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import Presentation
import SwiftUI

struct PersonDetailsContentView: View {

    var person: Person
    var knownForState: ViewState<[KnownForItem]>
    var isFocalPointEnabled: Bool
    var didSelectKnownForItem: (_ item: KnownForItem) -> Void

    private static let toolbarHeaderScrollThreshold: CGFloat = 200
    private static let maxProfileSize: CGFloat = 300

    @State private var showToolbarHeader = false

    var body: some View {
        ScrollView {
            profileImage
                .frame(width: 300, height: 300)
                .clipShape(.circle)
                .overlay {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                }

            VStack {
                Text(verbatim: person.name)
                    .font(.title)
                    .padding(.bottom)

                Text(verbatim: person.biography)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal)
            .padding(.bottom)

            knownForSection
        }
        .onScrollGeometryChange(for: Bool.self) { geometry in
            geometry.contentOffset.y > Self.toolbarHeaderScrollThreshold
        } action: { _, shouldShow in
            if shouldShow != showToolbarHeader {
                withAnimation {
                    showToolbarHeader = shouldShow
                }
            }
        }
        .navigationTitle(person.name)
        #if os(iOS)
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    ZStack {
                        Color.clear.frame(height: 0)
                        if showToolbarHeader {
                            PersonToolbarHeader(
                                name: person.name,
                                profileURL: person.smallProfileURL,
                                initials: person.initials
                            )
                            .transition(.opacity)
                        }
                    }
                }
            }
        #endif
    }

}

extension PersonDetailsContentView {

    @ViewBuilder
    private var profileImage: some View {
        let image = ProfileImage(url: person.profileURL, initials: person.initials)
        if isFocalPointEnabled {
            image.focalPointAlignment()
        } else {
            image
        }
    }

    @ViewBuilder
    private var knownForSection: some View {
        switch knownForState {
        case .loading:
            VStack(alignment: .leading, spacing: .spacing8) {
                SectionHeader(Text("KNOWN_FOR", bundle: .module))
                CarouselPlaceholder(shape: .backdrop)
                    .padding(.leading, .spacing16)
                    .accessibilityElement()
                    .accessibilityLabel(Text("LOADING", bundle: .module))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom)
        case .ready(let items) where !items.isEmpty:
            VStack(alignment: .leading, spacing: .spacing8) {
                SectionHeader(Text("KNOWN_FOR", bundle: .module))
                KnownForCarousel(items: items, didSelectItem: didSelectKnownForItem)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom)
        default:
            EmptyView()
        }
    }

}

#Preview {
    NavigationStack {
        PersonDetailsContentView(
            person: Person.mock,
            knownForState: .ready(KnownForItem.mocks),
            isFocalPointEnabled: true,
            didSelectKnownForItem: { _ in }
        )
    }
}
