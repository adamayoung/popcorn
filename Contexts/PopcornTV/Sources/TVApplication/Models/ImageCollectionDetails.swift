//
//  ImageCollectionDetails.swift
//  PopcornTV
//
//  Created by Adam Young on 24/11/2025.
//

import CoreDomain
import Foundation

public struct ImageCollectionDetails: Sendable {

    public let id: Int
    public let posterURLSets: [ImageURLSet]
    public let backdropURLSets: [ImageURLSet]
    public let logoURLSets: [ImageURLSet]

    public init(
        id: Int,
        posterURLSets: [ImageURLSet],
        backdropURLSets: [ImageURLSet],
        logoURLSets: [ImageURLSet]
    ) {
        self.id = id
        self.posterURLSets = posterURLSets
        self.backdropURLSets = backdropURLSets
        self.logoURLSets = logoURLSets
    }

}
