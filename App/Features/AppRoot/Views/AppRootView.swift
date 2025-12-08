//
//  AppRootView.swift
//  Popcorn
//
//  Created by Adam Young on 17/11/2025.
//

import ComposableArchitecture
import SwiftUI

struct AppRootView: View {

    @Bindable var store: StoreOf<AppRootFeature>
    @State private var customization = TabViewCustomization()

    var body: some View {
        content
            .task {
                store.send(.didAppear)
            }
    }

    private var content: some View {
        TabView(selection: $store.selectedTab) {
            Tab("HOME", systemImage: "house", value: AppRootFeature.Tab.explore) {
                ExploreRootView(
                    store: store.scope(
                        state: \.explore,
                        action: \.explore
                    )
                )
            }
            .customizationID(AppRootFeature.Tab.explore.id)

            Tab("MOVIES", systemImage: "film", value: AppRootFeature.Tab.movies) {
                MoviesRootView(
                    store: store.scope(
                        state: \.movies,
                        action: \.movies
                    )
                )
            }
            .customizationID(AppRootFeature.Tab.movies.id)

            Tab("TV", systemImage: "tv", value: AppRootFeature.Tab.tv) {
                TVRootView(
                    store: store.scope(
                        state: \.tv,
                        action: \.tv
                    )
                )
            }
            .customizationID(AppRootFeature.Tab.tv.id)

            Tab("PEOPLE", systemImage: "person", value: AppRootFeature.Tab.people) {
                PeopleRootView(
                    store: store.scope(
                        state: \.people,
                        action: \.people
                    )
                )
            }
            .customizationID(AppRootFeature.Tab.people.id)

            if store.isSearchEnabled {
                Tab(
                    "SEARCH",
                    systemImage: "magnifyingglass",
                    value: AppRootFeature.Tab.search,
                    role: .search
                ) {
                    SearchRootView(
                        store: store.scope(
                            state: \.search,
                            action: \.search
                        )
                    )
                }
                .customizationID(AppRootFeature.Tab.search.id)
            }
        }
        #if !os(macOS)
            .tabViewStyle(.sidebarAdaptable)
            .tabViewCustomization($customization)
        #else
            .tabViewStyle(.sidebarAdaptable)
            .tabViewCustomization($customization)
        #endif
        .minimizeTabBar()
    }

}

extension View {

    @ViewBuilder fileprivate func minimizeTabBar() -> some View {
        #if os(iOS)
            if #available(iOS 26.0, *) {
                self.tabBarMinimizeBehavior(.onScrollDown)
            } else {
                self
            }
        #else
            self
        #endif
    }

}

#Preview {
    AppRootView(
        store: Store(
            initialState: AppRootFeature.State(),
            reducer: {
                AppRootFeature()
            }
        )
    )
}
