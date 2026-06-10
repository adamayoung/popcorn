//
//  DeveloperViewSnapshotTests.swift
//  DeveloperFeature
//
//  Copyright © 2026 Adam Young.
//

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
            makeFeatureFlags: {
                .preview(viewState: .ready(.init(featureFlags: FeatureFlag.mocks)))
            }
        )

        verifyViewSnapshot(of: view)
    }

}
