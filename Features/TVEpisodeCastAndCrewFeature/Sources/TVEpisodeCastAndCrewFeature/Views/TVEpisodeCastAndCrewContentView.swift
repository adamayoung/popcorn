//
//  TVEpisodeCastAndCrewContentView.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import SwiftUI

struct TVEpisodeCastAndCrewContentView: View {

    var castMembers: [CastMember]
    var crewMembers: [CrewMember]
    var crewByDepartment: [String: [CrewMember]]
    var transitionNamespace: Namespace.ID
    var didSelectPerson: (_ personID: Int, _ transitionID: String?) -> Void

    var body: some View {
        List {
            if !castMembers.isEmpty {
                CastSection(
                    castMembers: castMembers,
                    transitionNamespace: transitionNamespace
                ) { personID, transitionID in
                    didSelectPerson(personID, transitionID)
                }
            }

            if !crewMembers.isEmpty {
                CrewSection(
                    crewByDepartment: crewByDepartment,
                    transitionNamespace: transitionNamespace
                ) { personID, transitionID in
                    didSelectPerson(personID, transitionID)
                }
            }
        }
        .navigationTitle(Text("CAST_AND_CREW", bundle: .module))
        #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
            .listStyle(.insetGrouped)
        #endif
    }

}

#Preview {
    @Previewable @Namespace var namespace

    NavigationStack {
        TVEpisodeCastAndCrewContentView(
            castMembers: CastMember.mocks,
            crewMembers: CrewMember.mocks,
            crewByDepartment: Dictionary(grouping: CrewMember.mocks, by: \.department),
            transitionNamespace: namespace,
            didSelectPerson: { _, _ in }
        )
    }
}
