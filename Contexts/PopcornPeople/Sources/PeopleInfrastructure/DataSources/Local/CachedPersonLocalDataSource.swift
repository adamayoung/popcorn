//
//  CachedPersonLocalDataSource.swift
//  PopcornPeople
//
//  Copyright © 2026 Adam Young.
//

import Caching
import Foundation
import PeopleDomain

actor CachedPersonLocalDataSource: PersonLocalDataSource {

    private let cache: any Caching

    init(cache: some Caching) {
        self.cache = cache
    }

    func person(withID id: Int) async -> Person? {
        await cache.item(forKey: .person(id: id), ofType: Person.self)
    }

    func setPerson(_ person: Person) async {
        await cache.setItem(person, forKey: .person(id: person.id))
    }

}

extension CacheKey {

    static func person(id: Int) -> CacheKey {
        CacheKey("PeopleKit.PeopleInfrastructure.person-\(id)")
    }

}
