//
//  StubAppConfigurationProvider.swift
//  PopcornSearchAdapters
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import SearchDomain

final class StubAppConfigurationProvider: AppConfigurationProviding, Sendable {

    func appConfiguration() async throws(AppConfigurationProviderError) -> AppConfiguration {
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
        return URL(string: "https://image.tmdb.org/t/p/w92\(path)")
    }

    private static func stubBackdropURLHandler(path: URL?, idealWidth: Int) -> URL? {
        guard let path = path?.absoluteString else {
            return nil
        }
        return URL(string: "https://image.tmdb.org/t/p/w300\(path)")
    }

    private static func stubLogoURLHandler(path: URL?, idealWidth: Int) -> URL? {
        guard let path = path?.absoluteString else {
            return nil
        }
        return URL(string: "https://image.tmdb.org/t/p/w45\(path)")
    }

    private static func stubProfileURLHandler(path: URL?, idealWidth: Int) -> URL? {
        guard let path = path?.absoluteString else {
            return nil
        }
        return URL(string: "https://image.tmdb.org/t/p/w45\(path)")
    }

}
