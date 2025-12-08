//
//  TVSeriesDetailsView.swift
//  TVSeriesDetailsFeature
//
//  Created by Adam Young on 18/11/2025.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct TVSeriesDetailsView: View {

    @Bindable private var store: StoreOf<TVSeriesDetailsFeature>
    private let namespace: Namespace.ID

    private var tvSeries: TVSeries? { store.tvSeries }
    private var isReady: Bool { store.isReady }

    public init(
        store: StoreOf<TVSeriesDetailsFeature>,
        transitionNamespace: Namespace.ID
    ) {
        self._store = .init(store)
        self.namespace = transitionNamespace
    }

    public var body: some View {
        ZStack {
            if isReady {
                loadedBody
            }
        }
        .contentTransition(.opacity)
        .animation(.easeInOut(duration: 1), value: isReady)
        .overlay {
            if !isReady {
                loadingBody
            }
        }
        .task { store.send(.load) }
    }

    private var loadingBody: some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    private var loadedBody: some View {
        StretchyHeaderScrollView(
            header: { header },
            headerOverlay: { headerOverlay },
            content: { content }
        )
        .navigationTitle(tvSeries?.name ?? "")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    @ViewBuilder
    private var header: some View {
        BackdropImage(url: tvSeries?.backdropURL)
            .flexibleHeaderContent(height: 600)
            .backgroundExtensionEffect()
    }

    @ViewBuilder
    private var headerOverlay: some View {
        LogoImage(url: tvSeries?.logoURL)
            .padding(.bottom, 20)
            .frame(maxWidth: 300, maxHeight: 150, alignment: .bottom)
    }

    @ViewBuilder
    private var content: some View {
        VStack(alignment: .leading) {
            Text(verbatim: tvSeries?.overview ?? "")
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal)
        }
        .padding(.bottom)
    }

}

#Preview {
    @Previewable @Namespace var namespace

    TVSeriesDetailsView(
        store: Store(
            initialState: TVSeriesDetailsFeature.State(id: 1),
            reducer: {
                TVSeriesDetailsFeature()
            }
        ),
        transitionNamespace: namespace
    )
}
