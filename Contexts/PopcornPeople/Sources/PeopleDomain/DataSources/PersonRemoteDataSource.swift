//
//  PersonRemoteDataSource.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public protocol PersonRemoteDataSource: Sendable {

    func person(withID id: Int) async throws(PersonRepositoryError) -> Person

}
