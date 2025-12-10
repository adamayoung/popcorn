//
//  PlotRemixGameView.swift
//  PlotRemixGameFeature
//
//  Created by Adam Young on 09/12/2025.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct PlotRemixGameView: View {

    @Bindable private var store: StoreOf<PlotRemixGameFeature>
    private let namespace: Namespace.ID

    public init(
        store: StoreOf<PlotRemixGameFeature>,
        transitionNamespace: Namespace.ID
    ) {
        self._store = .init(store)
        self.namespace = transitionNamespace
    }

    public var body: some View {
        Text("Plot Remix!")
    }

}

#Preview {
    @Previewable @Namespace var namespace

    PlotRemixGameView(
        store: Store(
            initialState: PlotRemixGameFeature.State(),
            reducer: {
                PlotRemixGameFeature()
            }
        ),
        transitionNamespace: namespace
    )
}
