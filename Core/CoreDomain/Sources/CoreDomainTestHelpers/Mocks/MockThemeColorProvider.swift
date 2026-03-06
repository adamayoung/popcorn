//
//  MockThemeColorProvider.swift
//  CoreDomain
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation

public final class MockThemeColorProvider: ThemeColorProviding, @unchecked Sendable {

    public var themeColorResult: ThemeColor?
    public var themeColorCallCount = 0
    public private(set) var themeColorCalledWith: [URL] = []

    public init(themeColorResult: ThemeColor? = nil) {
        self.themeColorResult = themeColorResult
    }

    public func themeColor(for posterThumbnailURL: URL) async -> ThemeColor? {
        themeColorCallCount += 1
        themeColorCalledWith.append(posterThumbnailURL)
        return themeColorResult
    }

}
