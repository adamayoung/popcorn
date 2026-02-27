//
//  SnapshotVerify.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import SnapshotTesting
import SwiftUI
import Testing

public func verifyViewSnapshot(
    of view: some View,
    named name: String? = nil,
    fileID: String = #fileID,
    file: StaticString = #filePath,
    line: Int = #line,
    column: Int = #column,
    testName: String = #function
) {
    let failure = verifySnapshot(
        of: view,
        as: .image(layout: .device(config: .snapshotDevice)),
        named: name,
        file: file,
        testName: testName
    )
    if let failure {
        Issue.record(
            Comment(rawValue: failure),
            sourceLocation: SourceLocation(
                fileID: fileID,
                filePath: String(describing: file),
                line: line,
                column: column
            )
        )
    }
}

extension ViewImageConfig {

    static let snapshotDevice: ViewImageConfig = .iPhone13Pro

}
