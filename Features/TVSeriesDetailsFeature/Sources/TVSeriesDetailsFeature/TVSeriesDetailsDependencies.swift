//
//  TVSeriesDetailsDependencies.swift
//  TVSeriesDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesApplication

/// The dependencies required by ``TVSeriesDetailsViewModel``.
///
/// A plain `Sendable` struct of closures providing the data dependencies for
/// ``TVSeriesDetailsViewModel``. Constructing it requires every closure, so a
/// missing dependency is a compile error. The production instance is built by the app's
/// composition layer; use ``preview`` for previews and tests.
public struct TVSeriesDetailsDependencies: Sendable {

    public var fetchTVSeries: @Sendable (_ id: Int) async throws -> TVSeries
    public var fetchCredits: @Sendable (_ tvSeriesID: Int) async throws -> Credits

    public var isCastAndCrewEnabled: @Sendable () throws -> Bool
    public var isIntelligenceEnabled: @Sendable () throws -> Bool
    public var isBackdropFocalPointEnabled: @Sendable () throws -> Bool

    public init(
        fetchTVSeries: @escaping @Sendable (_ id: Int) async throws -> TVSeries,
        fetchCredits: @escaping @Sendable (_ tvSeriesID: Int) async throws -> Credits,
        isCastAndCrewEnabled: @escaping @Sendable () throws -> Bool,
        isIntelligenceEnabled: @escaping @Sendable () throws -> Bool,
        isBackdropFocalPointEnabled: @escaping @Sendable () throws -> Bool
    ) {
        self.fetchTVSeries = fetchTVSeries
        self.fetchCredits = fetchCredits
        self.isCastAndCrewEnabled = isCastAndCrewEnabled
        self.isIntelligenceEnabled = isIntelligenceEnabled
        self.isBackdropFocalPointEnabled = isBackdropFocalPointEnabled
    }

}

#if DEBUG
    public extension TVSeriesDetailsDependencies {

        /// Mock dependencies for previews and snapshot tests.
        static var preview: TVSeriesDetailsDependencies {
            TVSeriesDetailsDependencies(
                fetchTVSeries: { _ in TVSeries.mock },
                fetchCredits: { _ in Credits.mock },
                isCastAndCrewEnabled: { true },
                isIntelligenceEnabled: { true },
                isBackdropFocalPointEnabled: { true }
            )
        }

    }
#endif
