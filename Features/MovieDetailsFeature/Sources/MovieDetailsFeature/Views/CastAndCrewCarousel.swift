//
//  CastAndCrewCarousel.swift
//  MovieDetailsFeature
//
//  Copyright © 2025 Adam Young.
//

import DesignSystem
import SwiftUI

struct CastAndCrewCarousel: View {

    var castMembers: [CastMember]
    var crewMembers: [CrewMember]
    var transitionNamespace: Namespace.ID?
    var didSelectPerson: (Int) -> Void

    var body: some View {
        Carousel {
            ForEach(castMembers) { castMember in
                Button {
                    didSelectPerson(castMember.personID)
                } label: {
                    ProfileCarouselCell(
                        imageURL: castMember.profileURL,
                        transitionNamespace: transitionNamespace
                    ) {
                        cellLabel(personName: castMember.personName, characterName: castMember.characterName)
                    }
                }
                .buttonStyle(.plain)
                .fixedSize(horizontal: true, vertical: false)
            }

            ForEach(crewMembers) { crewMember in
                Button {
                    didSelectPerson(crewMember.personID)
                } label: {
                    ProfileCarouselCell(
                        imageURL: crewMember.profileURL,
                        transitionNamespace: transitionNamespace
                    ) {
                        cellLabel(personName: crewMember.personName, characterName: crewMember.job)
                    }
                }
                .buttonStyle(.plain)
                .fixedSize(horizontal: true, vertical: false)
            }
        }
        .contentMargins([.leading, .trailing], 16)
    }

    @ViewBuilder
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
            transitionNamespace: transitionNamespace,
            didSelectPerson: { _ in }
        )
    }
}
