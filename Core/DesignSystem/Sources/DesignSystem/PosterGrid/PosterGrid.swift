//
//  PosterGrid.swift
//  DesignSystem
//
//  Copyright © 2026 Adam Young.
//

import SwiftUI

/// An adaptive, paginating grid of poster images.
///
/// Renders `items` as an adaptive `LazyVGrid` of tappable posters — three across
/// on every iPhone width, more on iPad and Mac — with a footer progress indicator
/// while the next page loads. It owns the grid, the poster cell chrome, the
/// per-cell pagination trigger, and the zoom-transition source; the surrounding
/// `ScrollView` and the loading / empty / error states stay with the feature that
/// composes it.
///
/// The grid is deliberately data-agnostic: each feature supplies small closures
/// describing how to read a poster URL, build a zoom-transition identifier, and
/// label a cell for its own presentation model. Pagination is driven per cell —
/// each cell's `.task` calls ``loadMore`` with its offset as it appears; the
/// feature's view model owns the threshold and decides whether to fetch, so the
/// grid stays free of paging policy.
///
/// - Note: Cell accessibility labels are applied verbatim (`Text(verbatim:)`), so
///   a title is never mistaken for a localization key. Supply a plain, already
///   user-facing string from ``accessibilityLabel``.
public struct PosterGrid<Item: Identifiable & Equatable>: View {

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let items: [Item]
    private let isLoadingMore: Bool
    private let transitionNamespace: Namespace.ID
    private let accessibilityIDPrefix: String
    private let accessibilityHint: Text
    private let posterURL: (Item) -> URL?
    private let transitionID: (Item) -> String
    private let accessibilityLabel: (Item) -> String
    private let onSelect: (Item, String) -> Void
    private let loadMore: (Int) async -> Void

    /// Creates an adaptive, paginating poster grid.
    ///
    /// - Parameters:
    ///   - items: The items to render, each shown as a poster cell.
    ///   - isLoadingMore: Whether a "load more" fetch is in flight; drives the
    ///     footer progress indicator.
    ///   - transitionNamespace: The namespace each poster publishes its zoom
    ///     transition source into; must be the one the destination zooms into.
    ///   - accessibilityIDPrefix: The prefix for cell identifiers; each cell is
    ///     `"\(prefix).movie.\(offset)"` and the footer is `"\(prefix).loadingMore"`.
    ///   - accessibilityHint: The hint spoken for every poster cell, describing
    ///     what activating it does. Supply localized `Text` from the feature bundle.
    ///   - posterURL: Reads the poster image URL for an item.
    ///   - transitionID: Builds the zoom-transition identifier for an item, used
    ///     both as the `matchedTransitionSource` id and passed to ``onSelect``.
    ///   - accessibilityLabel: Reads the verbatim accessibility label for an item.
    ///   - onSelect: Called with the item and its transition identifier when a
    ///     poster is tapped.
    ///   - loadMore: Called from each cell's `.task` with the cell's offset, so the
    ///     feature can request the next page as the end approaches.
    public init(
        items: [Item],
        isLoadingMore: Bool,
        transitionNamespace: Namespace.ID,
        accessibilityIDPrefix: String,
        accessibilityHint: Text,
        posterURL: @escaping (Item) -> URL?,
        transitionID: @escaping (Item) -> String,
        accessibilityLabel: @escaping (Item) -> String,
        onSelect: @escaping (Item, String) -> Void,
        loadMore: @escaping (Int) async -> Void
    ) {
        self.items = items
        self.isLoadingMore = isLoadingMore
        self.transitionNamespace = transitionNamespace
        self.accessibilityIDPrefix = accessibilityIDPrefix
        self.accessibilityHint = accessibilityHint
        self.posterURL = posterURL
        self.transitionID = transitionID
        self.accessibilityLabel = accessibilityLabel
        self.onSelect = onSelect
        self.loadMore = loadMore
    }

    public var body: some View {
        VStack(spacing: .spacing16) {
            LazyVGrid(columns: Self.columns, spacing: .spacing16) {
                ForEach(items.enumerated(), id: \.element.id) { offset, item in
                    let transitionID = transitionID(item)

                    Button {
                        onSelect(item, transitionID)
                    } label: {
                        PosterImage(url: posterURL(item))
                            .aspectRatio(Self.posterAspectRatio, contentMode: .fit)
                            .clipShape(.rect(cornerRadius: Self.cornerRadius))
                            .overlay {
                                RoundedRectangle(cornerRadius: Self.cornerRadius)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            }
                    }
                    .accessibilityIdentifier("\(accessibilityIDPrefix).movie.\(offset)")
                    .accessibilityLabel(Text(verbatim: accessibilityLabel(item)))
                    .accessibilityHint(accessibilityHint)
                    .buttonStyle(.plain)
                    .matchedTransitionSource(id: transitionID, in: transitionNamespace)
                    .task {
                        await loadMore(offset)
                    }
                }
            }
            .animation(reduceMotion ? nil : .default, value: items)

            if isLoadingMore {
                ProgressView()
                    .padding(.vertical, .spacing16)
                    .accessibilityLabel(Text("LOADING", bundle: .module))
                    .accessibilityIdentifier("\(accessibilityIDPrefix).loadingMore")
            }
        }
    }

}

extension PosterGrid {

    /// A 100pt minimum keeps three posters across on every iPhone width
    /// (375–440pt) while letting iPad and Mac fit more.
    private static var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 100), spacing: .spacing16)]
    }

    /// The standard poster aspect ratio (2:3).
    private static var posterAspectRatio: CGFloat {
        500.0 / 750.0
    }

    /// The corner radius applied to each poster and its border overlay.
    private static var cornerRadius: CGFloat {
        10
    }

}

#if DEBUG
    #Preview {
        @Previewable @Namespace var namespace

        struct PreviewPoster: Identifiable, Equatable {
            let id: Int
            let title: String
            let url: URL?
        }

        let posters = (1 ... 6).map {
            PreviewPoster(
                id: $0,
                title: "Movie \($0)",
                url: URL(string: "https://image.tmdb.org/t/p/w342/5rhTDKUhPYvpdQIijFIs5VoWsON.jpg")
            )
        }

        return ScrollView {
            PosterGrid(
                items: posters,
                isLoadingMore: false,
                transitionNamespace: namespace,
                accessibilityIDPrefix: "preview",
                accessibilityHint: Text(verbatim: "View details"),
                posterURL: \.url,
                transitionID: { "\($0.id)_preview" },
                accessibilityLabel: \.title,
                onSelect: { _, _ in },
                loadMore: { _ in }
            )
            .padding()
        }
    }
#endif
