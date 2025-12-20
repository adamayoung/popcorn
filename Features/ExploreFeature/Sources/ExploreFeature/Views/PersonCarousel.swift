//
//  PersonCarousel.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import DesignSystem
import SwiftUI

struct PersonCarousel: View {

    var people: [PersonPreview]
    var transitionNamespace: Namespace.ID?
    var didSelectPerson: (PersonPreview, String) -> Void

    var body: some View {
        Carousel {
            ForEach(Array(people.enumerated()), id: \.offset) { offset, person in
                let transitionID = TransitionID(person: person).value

                Button {
                    didSelectPerson(person, transitionID)
                } label: {
                    ProfileCarouselCell(
                        imageURL: person.profileURL,
                        transitionID: transitionID,
                        transitionNamespace: transitionNamespace
                    ) {
                        cellLabel(title: person.name, index: offset)
                    }
                }
                .buttonStyle(.plain)
                .fixedSize(horizontal: true, vertical: false)
            }
        }
        .contentMargins([.leading, .trailing], 16)
    }

    @ViewBuilder
    private func cellLabel(title: String, index: Int) -> some View {
        HStack(alignment: .top, spacing: 15) {
            Text(verbatim: "\(index + 1)")
                .font(.title)
                .bold()
                .foregroundStyle(Color.secondary)

            Text(verbatim: title)
                .lineLimit(2, reservesSpace: true)
                .multilineTextAlignment(.leading)

            Spacer()
        }
        .fixedSize(horizontal: false, vertical: true)
    }

}

#Preview {
    @Previewable @Namespace var transitionNamespace

    ScrollView {
        PersonCarousel(
            people: PersonPreview.mocks,
            transitionNamespace: transitionNamespace,
            didSelectPerson: { _, _ in }
        )
    }
}
