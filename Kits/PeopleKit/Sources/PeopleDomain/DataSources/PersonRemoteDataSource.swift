//
//  PersonRemoteDataSource.swift
//  PeopleKit
//
//  Created by Adam Young on 18/11/2025.
//

import Foundation

public protocol PersonRemoteDataSource: Sendable {

    func person(withID id: Int) async throws(PersonRepositoryError) -> Person

}
