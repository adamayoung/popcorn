//
//  TestSignal.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

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
