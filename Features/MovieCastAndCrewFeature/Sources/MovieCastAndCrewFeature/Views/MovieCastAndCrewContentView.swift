//
//  MovieCastAndCrewContentView.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import SwiftUI

struct MovieCastAndCrewContentView: View {

    var castMembers: [CastMember]
    var crewByDepartment: [CrewDepartment]
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

            if !crewByDepartment.isEmpty {
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
        MovieCastAndCrewContentView(
            castMembers: CastMember.mocks,
            crewByDepartment: CrewDepartment.mocks,
            transitionNamespace: namespace,
            didSelectPerson: { _, _ in }
        )
    }
}
