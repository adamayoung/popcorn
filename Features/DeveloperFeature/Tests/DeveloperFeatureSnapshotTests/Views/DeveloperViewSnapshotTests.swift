//
//  DeveloperViewSnapshotTests.swift
//  DeveloperFeature
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
@testable import DeveloperFeature
import Foundation
import SnapshotTestHelpers
import SwiftUI
import Testing

@Suite("DeveloperViewSnapshotTests", .snapshots(record: .missing))
@MainActor
struct DeveloperViewSnapshotTests {

    @Test
    func developerView() {
        let view = DeveloperView(
            store: Store(
                initialState: DeveloperFeature.State(),
                reducer: { EmptyReducer() }
            )
        )

        verifyViewSnapshot(of: view)
    }

}
