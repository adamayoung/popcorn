//
//  PersonDetailsView.swift
//  PersonDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import SwiftUI
import TCAFoundation

public struct PersonDetailsView: View {

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

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
        ZStack {
            switch store.viewState {
            case .ready(let snapshot):
                content(person: snapshot.person)
            case .error(let error):
                errorBody(error)
            default:
                EmptyView()
            }
        }
        .accessibilityIdentifier("person-details.view")
        .contentTransition(.opacity)
        .animation(
            reduceMotion ? nil : .easeInOut(duration: 1),
            value: store.viewState.isReady || store.viewState.isError
        )
        .overlay {
            if store.viewState.isLoading {
                loadingBody
            }
        }
        .onAppear {
            store.send(.didAppear)
        }
        .task {
            store.send(.fetch)
        }
    }

}

extension PersonDetailsView {

    private var loadingBody: some View {
        ProgressView()
            .accessibilityLabel(Text("LOADING", bundle: .module))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

}

extension PersonDetailsView {

    private func content(person: Person) -> some View {
        PersonDetailsContentView(
            person: person,
            isFocalPointEnabled: store.isFocalPointEnabled
        )
    }

}

extension PersonDetailsView {

    private func errorBody(_ error: ViewStateError) -> some View {
        ContentUnavailableView {
            Label(
                LocalizedStringResource("UNABLE_TO_LOAD", bundle: .module),
                systemImage: "exclamationmark.triangle"
            )
        } description: {
            Text(error.message)
        } actions: {
            if error.isRetryable {
                Button {
                    store.send(.fetch)
                } label: {
                    Text("RETRY", bundle: .module)
                }
                .buttonStyle(.bordered)
            }
        }
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
