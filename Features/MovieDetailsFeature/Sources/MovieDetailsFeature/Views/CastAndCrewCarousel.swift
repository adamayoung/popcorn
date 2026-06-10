//
//  CastAndCrewCarousel.swift
//  MovieDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import SwiftUI

struct CastAndCrewCarousel: View {

    var castMembers: [CastMember]
    var crewMembers: [CrewMember]
    var didSelectPerson: (Int) -> Void

    var body: some View {
        Carousel {
            ForEach(Array(castMembers.enumerated()), id: \.offset) { offset, castMember in
                Button {
                    didSelectPerson(castMember.personID)
                } label: {
                    ProfileCarouselCell(imageURL: castMember.profileURL, initials: castMember.initials) {
                        cellLabel(personName: castMember.personName, characterName: castMember.characterName)
                    }
                }
                .accessibilityIdentifier("movie-details.cast-and-crew.cast.\(offset)")
                .accessibilityLabel(Text(verbatim: castMember.personName))
                .accessibilityHint(Text("VIEW_PERSON_DETAILS_HINT", bundle: .module))
                .buttonStyle(.plain)
                .fixedSize(horizontal: true, vertical: false)
            }

            ForEach(Array(crewMembers.enumerated()), id: \.offset) { offset, crewMember in
                Button {
                    didSelectPerson(crewMember.personID)
                } label: {
                    ProfileCarouselCell(imageURL: crewMember.profileURL, initials: crewMember.initials) {
                        cellLabel(personName: crewMember.personName, characterName: crewMember.job)
                    }
                }
                .accessibilityIdentifier("movie-details.cast-and-crew.crew.\(offset)")
                .accessibilityLabel(Text(verbatim: crewMember.personName))
                .accessibilityHint(Text("VIEW_PERSON_DETAILS_HINT", bundle: .module))
                .buttonStyle(.plain)
                .fixedSize(horizontal: true, vertical: false)
            }
        }
        .accessibilityIdentifier("movie-details.cast-and-crew.carousel")
        .contentMargins([.leading, .trailing], 16)
    }

    private func cellLabel(personName: String, characterName: String) -> some View {
        VStack(alignment: .center) {
            Text(verbatim: personName)
                .lineLimit(2)
                .multilineTextAlignment(.center)

            Text(verbatim: characterName)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)

            Spacer()
        }
    }

}

#Preview {
    @Previewable @Namespace var transitionNamespace

    ScrollView {
        CastAndCrewCarousel(
            castMembers: CastMember.mocks,
            crewMembers: CrewMember.mocks,
            didSelectPerson: { _ in }
        )
    }
}
