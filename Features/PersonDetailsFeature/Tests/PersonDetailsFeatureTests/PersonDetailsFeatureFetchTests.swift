//
//  PersonDetailsFeatureFetchTests.swift
//  PersonDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
@testable import PersonDetailsFeature
import TCAFoundation
import Testing

@MainActor
@Suite("PersonDetailsFeature fetch Tests")
struct PersonDetailsFeatureFetchTests {

    @Test("fetch success loads person")
    func fetchSuccessLoadsPerson() async {
        let person = Self.testPerson
        let expectedSnapshot = PersonDetailsFeature.ViewSnapshot(person: person)

        let store = TestStore(
            initialState: PersonDetailsFeature.State(personID: 2283)
        ) {
            PersonDetailsFeature()
        } withDependencies: {
            $0.personDetailsClient.fetchPerson = { id in
                #expect(id == 2283)
                return person
            }
        }

        await store.send(.fetch)

        await store.receive(\.loaded) {
            $0.viewState = .ready(expectedSnapshot)
        }
    }

    @Test("fetch failure sends loadFailed with error")
    func fetchFailureSendsLoadFailed() async {
        let store = TestStore(
            initialState: PersonDetailsFeature.State(personID: 2283)
        ) {
            PersonDetailsFeature()
        } withDependencies: {
            $0.personDetailsClient.fetchPerson = { _ in
                throw TestError.generic
            }
        }

        await store.send(.fetch)

        await store.receive(\.loadFailed) {
            $0.viewState = .error(ViewStateError(TestError.generic))
        }
    }

    @Test("fetch when ready transitions to loading")
    func fetchWhenReadyTransitionsToLoading() async {
        let person = Self.testPerson
        let snapshot = PersonDetailsFeature.ViewSnapshot(person: person)

        let store = TestStore(
            initialState: PersonDetailsFeature.State(
                personID: 2283,
                viewState: .ready(snapshot)
            )
        ) {
            PersonDetailsFeature()
        } withDependencies: {
            $0.personDetailsClient.fetchPerson = { _ in person }
        }

        await store.send(.fetch) {
            $0.viewState = .loading
        }

        await store.receive(\.loaded) {
            $0.viewState = .ready(snapshot)
        }
    }

    @Test("fetch when error transitions to loading")
    func fetchWhenErrorTransitionsToLoading() async {
        let person = Self.testPerson
        let snapshot = PersonDetailsFeature.ViewSnapshot(person: person)

        let store = TestStore(
            initialState: PersonDetailsFeature.State(
                personID: 2283,
                viewState: .error(ViewStateError(message: "Previous error"))
            )
        ) {
            PersonDetailsFeature()
        } withDependencies: {
            $0.personDetailsClient.fetchPerson = { _ in person }
        }

        await store.send(.fetch) {
            $0.viewState = .loading
        }

        await store.receive(\.loaded) {
            $0.viewState = .ready(snapshot)
        }
    }

    @Test("loaded sets viewState to ready")
    func loadedSetsViewStateToReady() async {
        let snapshot = PersonDetailsFeature.ViewSnapshot(
            person: Person(
                id: 2283,
                name: "Test Person",
                biography: "Biography",
                knownForDepartment: "Acting",
                gender: .male
            )
        )

        let store = TestStore(
            initialState: PersonDetailsFeature.State(personID: 2283)
        ) {
            PersonDetailsFeature()
        }

        await store.send(.loaded(snapshot)) {
            $0.viewState = .ready(snapshot)
        }
    }

    @Test("loadFailed sets viewState to error")
    func loadFailedSetsViewStateToError() async {
        let error = ViewStateError(message: "Failed to load person")

        let store = TestStore(
            initialState: PersonDetailsFeature.State(personID: 2283)
        ) {
            PersonDetailsFeature()
        }

        await store.send(.loadFailed(error)) {
            $0.viewState = .error(error)
        }
    }

    @Test("didAppear sends updateFeatureFlags")
    func didAppearSendsUpdateFeatureFlags() async {
        let store = TestStore(
            initialState: PersonDetailsFeature.State(personID: 2283)
        ) {
            PersonDetailsFeature()
        } withDependencies: {
            $0.personDetailsClient.isFocalPointEnabled = { false }
        }

        await store.send(.didAppear)

        await store.receive(\.updateFeatureFlags)
    }

}

// MARK: - Test Data

extension PersonDetailsFeatureFetchTests {

    static let testPerson = Person(
        id: 2283,
        name: "Stanley Tucci",
        biography: "Stanley Tucci Jr. is an American actor.",
        knownForDepartment: "Acting",
        gender: .male,
        profileURL: URL(string: "https://example.com/profile.jpg"),
        initials: "ST"
    )

}

// MARK: - Test Helpers

private enum TestError: Error, Equatable {
    case generic
}
