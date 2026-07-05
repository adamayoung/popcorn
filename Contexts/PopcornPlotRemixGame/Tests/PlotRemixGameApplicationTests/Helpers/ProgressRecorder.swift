//
//  ProgressRecorder.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Synchronization

/// Thread-safe collector for the `@Sendable` progress callback passed to
/// `GeneratePlotRemixGameUseCase.execute(config:progress:)`, which can be invoked
/// concurrently from multiple child tasks.
final class ProgressRecorder: Sendable {

    private let storage = Mutex<[Float]>([])

    var values: [Float] {
        storage.withLock { $0 }
    }

    func append(_ value: Float) {
        storage.withLock { $0.append(value) }
    }

}
