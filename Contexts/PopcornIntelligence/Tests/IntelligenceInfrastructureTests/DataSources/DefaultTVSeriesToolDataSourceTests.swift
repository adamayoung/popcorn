//
//  DefaultTVSeriesToolDataSourceTests.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import IntelligenceDomain
import Testing

@testable import IntelligenceInfrastructure

@Suite("DefaultTVSeriesToolDataSource")
struct DefaultTVSeriesToolDataSourceTests {

    let mockTVSeriesProvider: MockTVSeriesProvider
    let dataSource: DefaultTVSeriesToolDataSource

    init() {
        self.mockTVSeriesProvider = MockTVSeriesProvider()
        self.dataSource = DefaultTVSeriesToolDataSource(tvSeriesProvider: mockTVSeriesProvider)
    }

    @Test("tvSeries returns TVSeriesTool")
    func tvSeriesReturnsTVSeriesTool() {
        let tool = dataSource.tvSeries()

        #expect(tool.name == "fetchTVSeriesDetails")
        #expect(tool.description == "Fetch details about a TV series.")
    }

}
