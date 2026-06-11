//
//  EPGManifestMapper.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsInfrastructure

struct EPGManifestMapper {

    /// The feed may or may not include fractional seconds in `generatedAt`; try both.
    /// `ISO8601DateFormatter` is thread-safe for parsing once configured.
    private nonisolated(unsafe) static let fractionalFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()

    private nonisolated(unsafe) static let formatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()

    func map(_ dto: EPGManifestDTO) -> EPGManifest {
        let generatedAt = Self.fractionalFormatter.date(from: dto.generatedAt)
            ?? Self.formatter.date(from: dto.generatedAt)
            ?? Date(timeIntervalSince1970: 0)

        return EPGManifest(
            generatedAt: generatedAt,
            dates: dto.dates,
            files: dto.files.map { file in
                EPGManifest.File(path: file.path, hash: file.hash, bytes: file.bytes)
            }
        )
    }

}
