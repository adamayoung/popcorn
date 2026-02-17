//
//  PersonRemoteDataSource.swift
//  PopcornPeople
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import PeopleDomain

public protocol PersonRemoteDataSource: Sendable {

    func person(withID id: Int) async throws(PersonRepositoryError) -> Person

}
