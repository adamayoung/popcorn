//
//  PopcornPeopleFactory.swift
//  PopcornPeople
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import PeopleApplication

public protocol PopcornPeopleFactory: Sendable {

    func makeFetchPersonDetailsUseCase() -> FetchPersonDetailsUseCase

}
