//
//  StubConfigurationRepository.swift
//  PopcornConfiguration
//
//  Copyright © 2025 Adam Young.
//

import ConfigurationDomain
import CoreDomain
import Foundation

public final class StubConfigurationRepository: ConfigurationRepository, Sendable {

    public init() {}

    public func configuration() async throws(ConfigurationRepositoryError) -> AppConfiguration {
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

extension StubConfigurationRepository {

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
