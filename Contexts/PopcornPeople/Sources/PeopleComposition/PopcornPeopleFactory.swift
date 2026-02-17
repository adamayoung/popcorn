//
//  PopcornPeopleFactory.swift
//  PopcornPeople
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import PeopleApplication

public protocol PopcornPeopleFactory: Sendable {

    func makeFetchPersonDetailsUseCase() -> FetchPersonDetailsUseCase

}
