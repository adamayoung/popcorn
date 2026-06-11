//
//  PopcornApp.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import SwiftUI

@main
struct PopcornApp: App {

    /// Drives the root tab view: startup lifecycle, tab selection, and per-tab
    /// feature-flag visibility.
    @State private var viewModel: AppRootViewModel

    /// The MVVM composition root. Builds feature view models from the shared
    /// ``AppServices`` graph.
    private let factory: ViewModelFactory

    init() {
        let services = AppServices()

        self.factory = ViewModelFactory(services: services)
        _viewModel = State(
            initialValue: AppRootViewModel(dependencies: .live(services: services))
        )
    }

    var body: some Scene {
        #if os(macOS)
            MacScene(viewModel: viewModel, factory: factory)
        #elseif os(visionOS)
            VisionScene(viewModel: viewModel, factory: factory)
        #else
            PhoneScene(viewModel: viewModel, factory: factory)
        #endif
    }

}
