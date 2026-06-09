//
//  TrendingPeopleView.swift
//  TrendingPeopleFeature
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import SwiftUI

/// The MVVM trending people view, driven by ``TrendingPeopleViewModel``.
///
/// A standalone leaf view: it owns its view model. Renders a store-free
/// `List` / `NavigationRow` / `PersonRow`.
public struct TrendingPeopleView: View {

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
            TrendingPeopleView(viewModel: .preview())
        }
    }
#endif
