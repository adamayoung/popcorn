//
//  FlexibleHeaderScrollViewModifier.swift
//  DesignSystem
//
//  Copyright © 2025 Adam Young.
//

import SwiftUI

@Observable
private class FlexibleHeaderGeometry {
    var offset: CGFloat = 0
    var viewHeight: CGFloat = 0
}

struct FlexibleHeaderScrollViewModifier: ViewModifier {

    @State private var viewGeometry = FlexibleHeaderGeometry()
    private var onChange: ((ScrollGeometry) -> Void)?

    init(onChange: ((ScrollGeometry) -> Void)? = nil) {
        self.onChange = onChange
    }

    func body(content: Content) -> some View {
        content
            .onScrollGeometryChange(for: ScrollGeometry.self) { geometry in
                geometry
            } action: { _, geometry in
                viewGeometry.offset = geometry.contentOffset.y
                viewGeometry.viewHeight = geometry.containerSize.height
                onChange?(geometry)
            }
            .environment(viewGeometry)
    }

}

private struct FlexibleHeaderContentModifier: ViewModifier {

    @Environment(FlexibleHeaderGeometry.self) private var viewGeometry

    private let height: CGFloat

    init(height: CGFloat) {
        self.height = height
    }

    func body(content: Content) -> some View {
        ZStack {
            content
                .frame(height: viewGeometry.offset >= 0 ? height : height - viewGeometry.offset)
                .offset(y: viewGeometry.offset >= 0 ? 0 : viewGeometry.offset / 2)
            //                .offset(y: viewGeometry.offset >= 0 ? viewGeometry.offset * 0.3 : viewGeometry.offset / 2)
        }
        .frame(height: height)
    }

}

public extension ScrollView {

    /// Enables flexible header behavior for the scroll view.
    ///
    /// When applied, the scroll view tracks scroll geometry and enables stretchy
    /// header effects for child views that use the ``flexibleHeaderContent(height:)`` modifier.
    ///
    /// - Parameter onChange: An optional closure called when scroll geometry changes.
    /// - Returns: A scroll view with flexible header behavior enabled.
    @MainActor
    func flexibleHeaderScrollView(onChange: ((ScrollGeometry) -> Void)? = nil) -> some View {
        modifier(FlexibleHeaderScrollViewModifier(onChange: onChange))
    }

}

public extension View {

    /// Marks this view as flexible header content that stretches when pulled down.
    ///
    /// Use this modifier on header content within a scroll view that has the
    /// ``flexibleHeaderScrollView(onChange:)`` modifier applied. The content will
    /// stretch beyond its normal height when the user pulls down on the scroll view.
    ///
    /// - Parameter height: The base height of the header content.
    /// - Returns: A view that responds to scroll gestures with a stretchy effect.
    func flexibleHeaderContent(height: CGFloat) -> some View {
        modifier(FlexibleHeaderContentModifier(height: height))
    }

}
