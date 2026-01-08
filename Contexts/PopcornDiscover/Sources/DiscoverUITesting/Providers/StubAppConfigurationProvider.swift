//
//  StubAppConfigurationProvider.swift
//  PopcornDiscover
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import DiscoverDomain
import Foundation

public final class StubAppConfigurationProvider: AppConfigurationProviding, Sendable {

    public init() {}

    public func appConfiguration() async throws(AppConfigurationProviderError) -> AppConfiguration {
        AppConfiguration(
            images: ImagesConfiguration(
                posterURLHandler: Self.stubPosterURLHandler,
                backdropURLHandler: Self.stubBackdropURLHandler,
                logoURLHandler: Self.stubLogoURLHandler,
                profileURLHandler: Self.stubProfileURLHandler
            )
        )
    }

}

extension StubAppConfigurationProvider {

    private static func stubPosterURLHandler(path: URL?, idealWidth: Int) -> URL? {
        guard let path = path?.absoluteString else {
            return nil
        }
        return URL(string: "https://image.tmdb.org/t/p/w342\(path)")
    }

    private static func stubBackdropURLHandler(path: URL?, idealWidth: Int) -> URL? {
        guard let path = path?.absoluteString else {
            return nil
        }
        return URL(string: "https://image.tmdb.org/t/p/w780\(path)")
    }

    private static func stubLogoURLHandler(path: URL?, idealWidth: Int) -> URL? {
        guard let path = path?.absoluteString else {
            return nil
        }
        return URL(string: "https://image.tmdb.org/t/p/w185\(path)")
    }

    private static func stubProfileURLHandler(path: URL?, idealWidth: Int) -> URL? {
        guard let path = path?.absoluteString else {
            return nil
        }
        return URL(string: "https://image.tmdb.org/t/p/w185\(path)")
    }

}
