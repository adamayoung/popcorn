//
//  FetchPersonDetailsUseCase.swift
//  PopcornPeople
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import PeopleDomain

public protocol FetchPersonDetailsUseCase: Sendable {

    func execute(id: Person.ID) async throws(FetchPersonDetailsError) -> PersonDetails

}
