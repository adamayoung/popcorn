//
//  ThemeColor+Mocks.swift
//  CoreDomain
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain

public extension ThemeColor {

    static func mock(
        red: Double = 0.5,
        green: Double = 0.3,
        blue: Double = 0.8
    ) -> ThemeColor {
        ThemeColor(red: red, green: green, blue: blue)
    }

}
