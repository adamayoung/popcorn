//
//  FixtureLoader.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

enum FixtureLoader {

    static func data(named name: String, extension ext: String = "json") throws -> Data {
        guard let url = Bundle.module.url(forResource: name, withExtension: ext) else {
            throw CocoaError(.fileReadNoSuchFile)
        }
        return try Data(contentsOf: url)
    }

}
