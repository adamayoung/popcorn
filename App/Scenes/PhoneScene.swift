//
//  PhoneScene.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

#if os(iOS)
    import SwiftUI

    struct PhoneScene: Scene {

        let viewModel: AppRootViewModel
        let factory: ViewModelFactory

        var body: some Scene {
            WindowGroup {
                AppRootView(viewModel: viewModel, factory: factory)
            }
        }

    }
#endif
