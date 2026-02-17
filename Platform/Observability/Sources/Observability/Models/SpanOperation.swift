//
//  SpanOperation.swift
//  Observability
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public struct SpanOperation: ExpressibleByStringLiteral, Sendable {
    public let value: String

    public init(_ value: String) {
        self.value = value
    }

    public init(stringLiteral value: String) {
        self.value = value
    }

    // UI Layer
    public static let uiAction = SpanOperation("ui.action")
    public static let uiLoad = SpanOperation("ui.load")

    /// Client Layer
    public static let clientFetch = SpanOperation("client.get")

    /// Use Case Layer
    public static let useCaseExecute = SpanOperation("usecase.execute")

    // Repository Layer
    public static let repositoryGet = SpanOperation("repository.get")
    public static let repositorySet = SpanOperation("repository.set")

    // Data Source Layer
    public static let localDataSourceGet = SpanOperation("localdatasource.get")
    public static let localDataSourceSet = SpanOperation("localdatasource.set")
    public static let remoteDataSourceGet = SpanOperation("remotedatasource.get")
    public static let remoteDataSourceSet = SpanOperation("remotedatasource.set")

    // Adapter Layer
    public static let providerGet = SpanOperation("provider.get")
    public static let providerSet = SpanOperation("provider.set")

    /// Infrastructure
    public static let tmdbClient = SpanOperation("tmdb.client")

    public static let cacheGet = SpanOperation("cache.get")
    public static let cacheSet = SpanOperation("cache.set")
    public static let cacheRemove = SpanOperation("cache.remove")
    public static let cacheFlush = SpanOperation("cache.flush")
}
