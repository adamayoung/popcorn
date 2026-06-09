//
//  TrendingPeopleScreen.swift
//  TrendingPeopleFeature
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import SwiftUI

/// The MVVM trending people screen, driven by ``TrendingPeopleViewModel``.
///
/// A standalone leaf screen: it owns its view model. Renders the same store-free
/// `List` / `NavigationRow` / `PersonRow` chrome as the former `TrendingPeopleView`.
public struct TrendingPeopleScreen: View {

    @State private var viewModel: TrendingPeopleViewModel

    public init(viewModel: TrendingPeopleViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    public var body: some View {
        List(viewModel.people) { person in
            NavigationRow {
                viewModel.selectPerson(id: person.id)
            } content: {
                PersonRow(
                    id: person.id,
                    name: person.name,
                    profileURL: person.profileURL,
                    initials: person.initials
                )
            }
        }
        .navigationTitle(Text("TRENDING", bundle: .module))
        .task {
            await viewModel.load()
        }
    }

}

#if DEBUG
    #Preview {
        NavigationStack {
            TrendingPeopleScreen(viewModel: .preview())
        }
    }
#endif
