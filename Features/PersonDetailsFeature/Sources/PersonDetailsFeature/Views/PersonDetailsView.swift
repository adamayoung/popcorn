//
//  PersonDetailsView.swift
//  PersonDetailsFeature
//
//  Created by Adam Young on 17/11/2025.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct PersonDetailsView: View {

    @Bindable private var store: StoreOf<PersonDetailsFeature>
    private let namespace: Namespace.ID

    public init(
        store: StoreOf<PersonDetailsFeature>,
        transitionNamespace: Namespace.ID
    ) {
        self._store = .init(store)
        self.namespace = transitionNamespace
    }

    public var body: some View {
        ScrollView {
            if let person = store.person {
                content(person: person)
            }
        }
        .overlay {
            if store.isLoading {
                ProgressView()
            }
        }
        .task {
            store.send(.loadPerson)
        }
    }

    @ViewBuilder
    private func content(person: Person) -> some View {
        ProfileImage(url: person.profileURL)
            .frame(width: 300, height: 300)
            .cornerRadius(150)
            .clipped()

        VStack {
            Text(verbatim: person.name)
                .font(.title)
                .padding(.bottom)

            Text(verbatim: person.biography)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal)
        .padding(.bottom)
    }

}

#Preview {
    @Previewable @Namespace var namespace

    NavigationStack {
        PersonDetailsView(
            store: Store(
                initialState: PersonDetailsFeature.State(id: 1),
                reducer: {
                    PersonDetailsFeature()
                }
            ),
            transitionNamespace: namespace
        )
    }
}
