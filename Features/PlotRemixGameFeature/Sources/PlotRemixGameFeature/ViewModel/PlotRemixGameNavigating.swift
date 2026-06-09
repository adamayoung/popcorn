//
//  PlotRemixGameNavigating.swift
//  PlotRemixGameFeature
//
//  Copyright © 2026 Adam Young.
//

/// Navigation actions a ``PlotRemixGameViewModel`` can request.
///
/// The root coordinator supplies a concrete implementation (a `RouterNavigator`)
/// that dismisses the modal. The MVVM replacement for the former
/// `PlotRemixGameFeature`'s `@Dependency(\.dismiss)`.
@MainActor
public protocol PlotRemixGameNavigating {

    func dismiss()

}

#if DEBUG
    /// A no-op navigator for previews and snapshot tests.
    public struct NoOpPlotRemixGameNavigator: PlotRemixGameNavigating {
        public init() {}
        public func dismiss() {}
    }
#endif
