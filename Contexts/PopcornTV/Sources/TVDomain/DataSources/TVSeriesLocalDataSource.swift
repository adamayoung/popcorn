//
//  TVSeriesLocalDataSource.swift
//  PopcornTV
//
//  Created by Adam Young on 25/11/2025.
//

import Foundation

public protocol TVSeriesLocalDataSource: Sendable, Actor {

    func tvSeries(withID id: Int) async -> TVSeries?

    func setTVSeries(_ tvSeries: TVSeries) async

    func images(forTVSeries tvSeriesID: Int) async -> ImageCollection?

    func setImages(_ imageCollection: ImageCollection, forTVSeries tvSeriesID: Int) async

}
