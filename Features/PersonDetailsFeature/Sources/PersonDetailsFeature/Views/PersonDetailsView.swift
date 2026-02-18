//
//  PersonDetailsView.swift
//  PersonDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI
import TCAFoundation

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
            switch store.viewState {
            case .ready(let snapshot):
                content(person: snapshot.person)
            case .error(let error):
                ContentUnavailableView {
                    Label("UNABLE_TO_LOAD", systemImage: "exclamationmark.triangle")
                } description: {
                    Text(error.message)
                } actions: {
                    if error.isRetryable {
                        Button("RETRY") {
                            store.send(.fetch)
                        }
                        .buttonStyle(.bordered)
                    }
                }
            default:
                EmptyView()
            }
        }
        .accessibilityIdentifier("person-details.view")
        .overlay {
            if store.viewState.isLoading {
                loadingBody
            }
        }
        .task {
            store.send(.fetch)
        }
    }

    private var loadingBody: some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    private func content(person: Person) -> some View {
        ProfileImage(url: person.profileURL)
            .frame(width: 300, height: 300)
            .clipShape(.circle)

        VStack {
            Text(verbatim: person.name)
                .font(.title)
                .padding(.bottom)

            Text(verbatim: person.biography)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal)
        .padding(.bottom)
        .navigationTitle(person.name)
        #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
        #endif
    }

}

#Preview("Ready") {
    @Previewable @Namespace var namespace

    NavigationStack {
        PersonDetailsView(
            store: Store(
                initialState: PersonDetailsFeature.State(
                    personID: Person.mock.id,
                    viewState: .ready(.init(person: Person.mock))
                ),
                reducer: {
                    EmptyReducer()
                }
            ),
            transitionNamespace: namespace
        )
    }
}

#Preview("Loading") {
    @Previewable @Namespace var namespace

    NavigationStack {
        PersonDetailsView(
            store: Store(
                initialState: PersonDetailsFeature.State(
                    personID: Person.mock.id,
                    viewState: .loading
                ),
                reducer: {
                    EmptyReducer()
                }
            ),
            transitionNamespace: namespace
        )
    }
}
