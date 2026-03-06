//
//  TVSeriesPreviewDetails.swift
//  PopcornSearch
//
//  Copyright © 2026 Adam Young.
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
    public let themeColor: ThemeColor?

    public init(
        id: Int,
        name: String,
        overview: String,
        posterURLSet: ImageURLSet? = nil,
        backdropURLSet: ImageURLSet? = nil,
        logoURLSet: ImageURLSet? = nil,
        themeColor: ThemeColor? = nil
    ) {
        self.id = id
        self.name = name
        self.overview = overview
        self.posterURLSet = posterURLSet
        self.backdropURLSet = backdropURLSet
        self.logoURLSet = logoURLSet
        self.themeColor = themeColor
    }

}
