//
//  TrendingPeopleView.swift
//  TrendingPeopleFeature
//
//  Created by Adam Young on 19/11/2025.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct TrendingPeopleView: View {

    @Bindable private var store: StoreOf<TrendingPeopleFeature>

    public init(store: StoreOf<TrendingPeopleFeature>) {
        self._store = .init(store)
    }

    public var body: some View {
        List(store.people) { person in
            NavigationRow {
                store.send(.navigate(.personDetails(id: person.id)))
            } content: {
                PersonRow(
                    id: person.id,
                    name: person.name,
                    profileURL: person.profileURL
                )
            }
        }
        .navigationTitle("Trending")
        .task {
            store.send(.loadTrendingPeople)
        }
    }

}

#Preview {
    TrendingPeopleView(
        store: Store(
            initialState: TrendingPeopleFeature.State(),
            reducer: {
                TrendingPeopleFeature()
            }
        )
    )
}
