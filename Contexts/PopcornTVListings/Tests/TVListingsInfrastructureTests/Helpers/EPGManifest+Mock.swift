//
//  EPGManifest+Mock.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import TVListingsInfrastructure

extension EPGManifest {

    ///
    /// Builds a manifest from a channels hash and per-date schedule hashes. `dates` defaults to
    /// the keys of `scheduleHashes` in the order given.
    ///
    static func mock(
        dates: [String],
        channelsHash: String? = "channels-v1",
        scheduleHashes: [String: String] = [:],
        generatedAt: Date = Date(timeIntervalSince1970: 0)
    ) -> EPGManifest {
        var files: [EPGManifest.File] = []

        if let channelsHash {
            files.append(EPGManifest.File(path: "channels.json", hash: channelsHash, bytes: 10))
        }

        for date in dates {
            guard let hash = scheduleHashes[date] else { continue }
            files.append(
                EPGManifest.File(path: "schedules/\(date).json", hash: hash, bytes: 10)
            )
        }

        return EPGManifest(generatedAt: generatedAt, dates: dates, files: files)
    }

}

///
/// A one-shot async signal usable as a gate in concurrency tests.
///
actor TestSignal {

    private var isSignalled = false
    private var continuations: [CheckedContinuation<Void, Never>] = []

    func wait() async {
        if isSignalled {
            return
        }
        await withCheckedContinuation { continuation in
            continuations.append(continuation)
        }
    }

    func signal() {
        isSignalled = true
        let pending = continuations
        continuations.removeAll()
        for continuation in pending {
            continuation.resume()
        }
    }

}
