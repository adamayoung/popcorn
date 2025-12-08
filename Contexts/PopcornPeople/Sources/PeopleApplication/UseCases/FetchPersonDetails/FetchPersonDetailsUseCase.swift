//
//  FetchPersonDetailsUseCase.swift
//  PopcornPeople
//
//  Created by Adam Young on 03/06/2025.
//

import Foundation
import PeopleDomain

public protocol FetchPersonDetailsUseCase: Sendable {

    func execute(id: Int) async throws(FetchPersonDetailsError) -> PersonDetails

}
