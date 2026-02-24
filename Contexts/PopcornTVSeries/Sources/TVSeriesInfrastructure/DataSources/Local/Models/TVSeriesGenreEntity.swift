//
//  TVSeriesGenreEntity.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SwiftData

@Model
final class TVSeriesGenreEntity: Equatable {

    var genreID: Int
    var name: String
    @Relationship(inverse: \TVSeriesEntity.genres) var tvSeries: TVSeriesEntity?

    init(genreID: Int, name: String) {
        self.genreID = genreID
        self.name = name
    }

}
