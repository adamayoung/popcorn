//
//  SectionHeader.swift
//  DesignSystem
//
//  Copyright © 2026 Adam Young.
//

import SwiftUI

/// A section header with a bold title and, when tappable, a trailing chevron.
///
/// Use it above a carousel or grid to label the section and, optionally, to
/// navigate to a full listing. Supply an `action` to render the chevron and make
/// the whole header a button; omit it for a plain, non-interactive title.
///
/// The title is provided as a caller-built `Text` so its localized key resolves
/// against the calling module's bundle — pass `Text("KEY", bundle: .module)`.
public struct SectionHeader: View {

    private let title: Text
    private let action: (() -> Void)?

    /// Creates a section header.
    /// - Parameters:
    ///   - title: The header title, localized by the caller
    ///     (e.g. `Text("CAST_AND_CREW", bundle: .module)`).
    ///   - action: An optional tap handler. When non-nil, the header renders a
    ///     trailing chevron and behaves as a button.
    public init(_ title: Text, action: (() -> Void)? = nil) {
        self.title = title
        self.action = action
    }

    public var body: some View {
        Group {
            if let action {
                Button(action: action) {
                    label
                }
                .buttonStyle(.plain)
            } else {
                titleText
            }
        }
        .accessibilityAddTraits(.isHeader)
        .padding(.horizontal)
    }

    private var label: some View {
        HStack(spacing: .spacing4) {
            titleText

            Image(systemName: "chevron.right")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
                .accessibilityHidden(true)
        }
    }

    private var titleText: Text {
        title
            .font(.title2)
            .fontWeight(.bold)
    }

}

#Preview {
    VStack(alignment: .leading, spacing: .spacing20) {
        SectionHeader(Text(verbatim: "Cast & Crew")) {}
        SectionHeader(Text(verbatim: "Recommended"))
    }
}
