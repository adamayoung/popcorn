//
//  ImageCollectionDetails.swift
//  PopcornTVSeries
//
//  Copyright © 2025 Adam Young.
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
