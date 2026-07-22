//
//  PersonCreditsView.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import Presentation
import SwiftUI

/// The person credits view, driven by ``PersonCreditsViewModel``.
///
/// Lists every movie and TV series a person is credited on, newest first, along
/// with its loading / error chrome.
public struct PersonCreditsView: View {

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var viewModel: PersonCreditsViewModel

    ///
    /// Creates a new person credits view.
    ///
    /// - Parameter viewModel: The view model driving this view.
    ///
    public init(viewModel: PersonCreditsViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    public var body: some View {
        ZStack {
            switch viewModel.viewState {
            case .ready(let snapshot):
                content(snapshot)
            case .error(let error):
                errorBody(error)
            default:
                EmptyView()
            }
        }
        .contentTransition(.opacity)
        .animation(reduceMotion ? nil : .easeInOut(duration: 1), value: viewModel.viewState.isReady)
        .overlay {
            if viewModel.viewState.isLoading {
                loadingBody
            }
        }
        .navigationTitle(Text("CREDITS", bundle: .module))
        #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
        #endif
            .task(id: viewModel.reloadID) {
                await viewModel.load()
            }
    }

}

extension PersonCreditsView {

    private var loadingBody: some View {
        ProgressView()
            .accessibilityLabel(Text("LOADING", bundle: .module))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

}

extension PersonCreditsView {

    @ViewBuilder
    private func content(_ snapshot: PersonCreditsViewSnapshot) -> some View {
        if snapshot.credits.isEmpty {
            emptyBody
        } else {
            creditsList(snapshot.credits)
        }
    }

    private var emptyBody: some View {
        ContentUnavailableView {
            Label {
                Text("NO_CREDITS", bundle: .module)
            } icon: {
                Image(systemName: "film")
            }
        } description: {
            Text("NO_CREDITS_DESCRIPTION", bundle: .module)
        }
    }

    private func creditsList(_ credits: [CreditItem]) -> some View {
        List {
            ForEach(credits) { item in
                Button {
                    viewModel.selectCredit(item)
                } label: {
                    CreditRow(item: item)
                }
                .buttonStyle(.plain)
                .accessibilityHint(accessibilityHint(for: item))
                .accessibilityIdentifier("person-credits.row.\(item.id)")
            }
        }
        #if os(iOS)
        .listStyle(.insetGrouped)
        #endif
    }

    private func accessibilityHint(for item: CreditItem) -> Text {
        switch item.mediaType {
        case .movie:
            Text("VIEW_MOVIE_DETAILS_HINT", bundle: .module)
        case .tvSeries:
            Text("VIEW_TV_SERIES_DETAILS_HINT", bundle: .module)
        }
    }

}

extension PersonCreditsView {

    private func errorBody(_ error: ViewStateError) -> some View {
        ContentLoadErrorView(
            message: error.message,
            systemImage: "film",
            reason: error.reason,
            isRetryable: error.isRetryable,
            retryAction: { viewModel.reload() }
        )
    }

}

#if DEBUG
    #Preview("Ready") {
        NavigationStack {
            PersonCreditsView(
                viewModel: .preview(
                    viewState: .ready(PersonCreditsViewSnapshot(credits: CreditItem.mocks))
                )
            )
        }
    }

    #Preview("Empty") {
        NavigationStack {
            PersonCreditsView(
                viewModel: .preview(
                    viewState: .ready(PersonCreditsViewSnapshot(credits: []))
                )
            )
        }
    }

    #Preview("Loading") {
        NavigationStack {
            PersonCreditsView(viewModel: .preview(viewState: .loading))
        }
    }
#endif
