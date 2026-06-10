//
//  MacScene.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

#if os(macOS)
    import SwiftUI

    struct MacScene: Scene {

        let viewModel: AppRootViewModel
        let factory: ViewModelFactory

        private let minWidth: CGFloat = 975
        private let minHeight: CGFloat = 570

        var body: some Scene {
            Window("MOVIES", id: "app") {
                AppRootView(viewModel: viewModel, factory: factory)
                    .frame(
                        minWidth: minWidth,
                        maxWidth: .infinity,
                        minHeight: minHeight,
                        maxHeight: .infinity
                    )
            }
            .windowResizability(.contentSize)
        }

    }

#endif
