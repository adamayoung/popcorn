//
//  UITestDependencies.swift
//  AppDependencies
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import ConfigurationUITesting
import Foundation

public enum UITestDependencies {

    public static func configure(_ dependencies: inout DependencyValues) {
        dependencies.configurationFactory = UITestPopcornConfigurationFactory()
    }

}
