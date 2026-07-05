//
//  CreditsMapper.swift
//  MovieDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesApplication

/// Maps a context ``CreditsDetails`` to the feature's ``Credits`` presentation model.
public struct CreditsMapper {

    /// Creates a credits mapper.
    public init() {}

    /// Maps a context ``CreditsDetails`` to a presentation ``Credits`` (top cast and crew).
    public func map(_ creditsDetails: CreditsDetails) -> Credits {
        Credits(
            id: creditsDetails.id,
            castMembers: creditsDetails.cast.prefix(5).map(map),
            crewMembers: creditsDetails.crew.prefix(5).map(map)
        )
    }

    private func map(_ castMemberDetails: CastMemberDetails) -> CastMember {
        CastMember(
            id: castMemberDetails.id,
            personID: castMemberDetails.personID,
            characterName: castMemberDetails.characterName,
            personName: castMemberDetails.personName,
            profileURL: castMemberDetails.profileURLSet?.detail,
            initials: castMemberDetails.initials
        )
    }

    private func map(_ crewMemberDetails: CrewMemberDetails) -> CrewMember {
        CrewMember(
            id: crewMemberDetails.id,
            personID: crewMemberDetails.personID,
            personName: crewMemberDetails.personName,
            job: crewMemberDetails.job,
            profileURL: crewMemberDetails.profileURLSet?.detail,
            department: crewMemberDetails.department,
            initials: crewMemberDetails.initials
        )
    }

}
