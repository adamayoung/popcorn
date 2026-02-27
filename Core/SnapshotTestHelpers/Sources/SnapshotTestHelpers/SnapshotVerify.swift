//
//  SnapshotVerify.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
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
        as: .image(layout: .device(config: .snapshotLayout)),
        named: name,
        file: file,
        testName: testName
    )
    if let failure {
        let sourceLocation = SourceLocation(
            fileID: fileID,
            filePath: String(describing: file),
            line: line,
            column: column
        )
        attachSnapshotImages(from: failure, sourceLocation: sourceLocation)
        Issue.record(Comment(rawValue: failure), sourceLocation: sourceLocation)
    }
}

private func attachSnapshotImages(from failure: String, sourceLocation: SourceLocation) {
    let lines = failure.components(separatedBy: "\n")

    for (index, line) in lines.enumerated() {
        let trimmed = line.trimmingCharacters(in: .whitespaces)
        guard trimmed == "@\u{2212}" || trimmed == "@+", index + 1 < lines.count else { continue }

        let urlString = lines[index + 1]
            .trimmingCharacters(in: .whitespaces)
            .trimmingCharacters(in: CharacterSet(charactersIn: "\""))

        guard let url = URL(string: urlString),
              let data = try? Data(contentsOf: url)
        else { continue }

        let name = trimmed == "@\u{2212}" ? "reference.png" : "actual.png"
        Attachment<Data>.record(data, named: name, sourceLocation: sourceLocation)
    }
}

extension ViewImageConfig {

    /// Pinned to iPhone 13 Pro dimensions (390 x 844 pt) for a stable baseline.
    static let snapshotLayout: ViewImageConfig = .iPhone13Pro

}
