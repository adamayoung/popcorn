//
//  FetchPersonDetailsUseCase.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import PeopleDomain

public protocol FetchPersonDetailsUseCase: Sendable {

    func execute(id: Person.ID) async throws(FetchPersonDetailsError) -> PersonDetails

}
