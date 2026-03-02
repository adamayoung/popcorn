//
//  Analysing.swift
//  Analytics
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public protocol Analysing: Sendable {

    func track(event: String, properties: [String: any Sendable]?)

    func setUserId(_ userId: String?)

    func setUserProperties(_ properties: [String: any Sendable])

    func reset()

}
