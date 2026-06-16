//
//  EPGManifest.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// The EPG manifest: an index of the available days and a content hash for every file,
/// used to download only the files that changed since the last sync.
///
public struct EPGManifest: Sendable, Equatable {

    ///
    /// A single file entry in the manifest.
    ///
    public struct File: Sendable, Equatable {

        public let path: String
        public let hash: String
        public let bytes: Int

        public init(path: String, hash: String, bytes: Int) {
            self.path = path
            self.hash = hash
            self.bytes = bytes
        }

    }

    public let generatedAt: Date
    public let dates: [String]
    public let files: [File]

    public init(generatedAt: Date, dates: [String], files: [File]) {
        self.generatedAt = generatedAt
        self.dates = dates
        self.files = files
    }

    /// The `channels.json` file entry, if present.
    public var channelsFile: File? {
        files.first { $0.path == "channels.json" }
    }

    /// The `regions.json` file entry, if present.
    public var regionsFile: File? {
        files.first { $0.path == "regions.json" }
    }

    /// The `schedules/<date>.json` file entry for the given `yyyyMMdd` date, if present.
    public func scheduleFile(forDate date: String) -> File? {
        files.first { $0.path == "schedules/\(date).json" }
    }

}
