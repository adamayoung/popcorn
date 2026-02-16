//
//  DeveloperView.swift
//  DeveloperFeature
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI
import TCAFoundation

public struct DeveloperView: View {

    @Bindable var store: StoreOf<DeveloperFeature>
    @Environment(\.dismiss) private var dismiss

    public init(store: StoreOf<DeveloperFeature>) {
        self._store = .init(store)
    }

    public var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            List {
                NavigationLink(
                    state: DeveloperFeature.Path.State.featureFlags(FeatureFlagsFeature.State())
                ) {
                    Text("FEATURE_FLAGS", bundle: .module)
                }
            }
            .navigationTitle(Text("DEVELOPER", bundle: .module))
            .accessibilityIdentifier("developer.view")
            .toolbar {
                ToolbarItem {
                    Button(role: .close) {
                        dismiss()
                    }
                }
            }
        } destination: { store in
            switch store.case {
            case .featureFlags(let store):
                FeatureFlagsView(store: store)
            }
        }
    }

}

#Preview {
    DeveloperView(
        store: Store(
            initialState: DeveloperFeature.State(),
            reducer: { EmptyReducer() }
        )
    )
}
