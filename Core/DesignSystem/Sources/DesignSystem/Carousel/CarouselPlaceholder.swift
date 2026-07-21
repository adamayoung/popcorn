//
//  CarouselPlaceholder.swift
//  DesignSystem
//
//  Copyright © 2026 Adam Young.
//

import SwiftUI

/// A placeholder shown in place of a ``Carousel`` while its content is loading.
///
/// Renders a row of neutral, fixed-size shapes matching the dimensions of the real
/// carousel cells, so a section can reserve its space and avoid a layout jump when
/// the data arrives. The shapes are purely decorative and carry no accessibility
/// semantics; attach an accessibility label at the call site if the loading state
/// should be announced.
public struct CarouselPlaceholder: View {

    /// The cell silhouette a placeholder should imitate.
    public enum Shape: Sendable {

        /// A 16:9 backdrop cell, matching ``BackdropCarouselCell``.
        case backdrop

        /// A circular profile cell, matching ``ProfileCarouselCell``.
        case profile
    }

    private let shape: Shape
    private let count: Int

    #if os(macOS) || os(visionOS)
        private let backdropWidth: CGFloat = 300
        private let profileWidth: CGFloat = 150
    #else
        private let backdropWidth: CGFloat = 250
        private let profileWidth: CGFloat = 150
    #endif

    /// The standard backdrop aspect ratio (16:9), matching `BackdropImage`.
    private let backdropAspectRatio: CGFloat = 3840.0 / 2160.0

    /// Creates a carousel placeholder.
    ///
    /// - Parameters:
    ///   - shape: The cell silhouette to imitate.
    ///   - count: The number of placeholder cells to render. Defaults to `3`.
    public init(shape: Shape, count: Int = 3) {
        self.shape = shape
        self.count = count
    }

    public var body: some View {
        Carousel {
            ForEach(0 ..< count, id: \.self) { _ in
                cell
            }
        }
    }

    @ViewBuilder
    private var cell: some View {
        switch shape {
        case .backdrop:
            RoundedRectangle(cornerRadius: 20)
                .fill(.quaternary)
                .frame(width: backdropWidth, height: backdropWidth / backdropAspectRatio)
        case .profile:
            Circle()
                .fill(.quaternary)
                .frame(width: profileWidth, height: profileWidth)
        }
    }

}

#Preview("Backdrop") {
    CarouselPlaceholder(shape: .backdrop)
        .padding()
}

#Preview("Profile") {
    CarouselPlaceholder(shape: .profile)
        .padding()
}
