//
//  CommandLine+Arguments.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

extension CommandLine {

    static var isUITesting: Bool {
        CommandLine.arguments.contains("-uitest")
    }

}
