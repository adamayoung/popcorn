//
//  TVSeriesPreviewDetails.swift
//  TrendingKit
//
//  Created by Adam Young on 20/11/2025.
//

import CoreDomain
import Foundation

public struct TVSeriesPreviewDetails: Identifiable, Equatable, Sendable {

    public let id: Int
    public let name: String
    public let overview: String
    public let posterURLSet: ImageURLSet?
    public let backdropURLSet: ImageURLSet?
    public let logoURLSet: ImageURLSet?

    public init(
        id: Int,
        name: String,
        overview: String,
        posterURLSet: ImageURLSet? = nil,
        backdropURLSet: ImageURLSet? = nil,
        logoURLSet: ImageURLSet? = nil
    ) {
        self.id = id
        self.name = name
        self.overview = overview
        self.posterURLSet = posterURLSet
        self.backdropURLSet = backdropURLSet
        self.logoURLSet = logoURLSet
    }

}
