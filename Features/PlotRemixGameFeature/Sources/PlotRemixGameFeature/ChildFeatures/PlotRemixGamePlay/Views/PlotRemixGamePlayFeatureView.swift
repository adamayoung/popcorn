//
//  PlotRemixGamePlayFeatureView.swift
//  PlotRemixGameFeature
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI
import TCAFoundation

public struct PlotRemixGamePlayFeatureView: View {

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Bindable private var store: StoreOf<PlotRemixGamePlayFeature>

    public init(store: StoreOf<PlotRemixGamePlayFeature>) {
        self._store = .init(store)
    }

    public var body: some View {
        NavigationStack {
            ZStack {
                TabView {
                    if case .ready(let snapshot) = store.viewState {
                        content(game: snapshot.game)
                    }
                }
                #if os(iOS)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                #endif

                Rectangle()
                    .fill(.clear)
                    .contentShape(Rectangle())
                    .gesture(DragGesture())
            }
            .frame(maxWidth: .infinity)
            .overlay {
                switch store.viewState {
                case .generating(let progress):
                    generatingBody(progress: progress)
                        .padding()

                case .error(let error):
                    ContentLoadErrorView(
                        message: error.message,
                        systemImage: "gamecontroller",
                        reason: error.reason,
                        isRetryable: error.isRetryable,
                        retryAction: { store.send(.generate) }
                    )

                default:
                    EmptyView()
                }
            }
            .background {
                AnimatedMeshBackground(baseColor: store.metadata.color)
                    .ignoresSafeArea()
            }
            .task { store.send(.generate) }
            .toolbar {
                ToolbarItem {
                    Button(role: .close) {
                        store.send(.close)
                    }
                }
            }
        }
    }

}

extension PlotRemixGamePlayFeatureView {

    private func generatingBody(progress: Float) -> some View {
        HStack {
            ProgressView(value: progress) {
                Text("GENERATING_GAME", bundle: .module)
            }
            .animation(reduceMotion ? nil : .easeIn(duration: 3), value: progress)
        }
    }

    private func content(game: Game) -> some View {
        ForEach(game.questions) { question in
            VStack(spacing: .spacing50) {
                Spacer()

                Text(verbatim: "\(question.riddle)")

                Spacer()

                #if os(visionOS)
                    answersView(options: question.options)
                #else
                    GlassEffectContainer(spacing: .spacing16) {
                        answersView(options: question.options)
                    }
                #endif
            }
            .padding()
        }
    }

    private func answersView(options: [AnswerOption]) -> some View {
        VStack(spacing: .spacing16) {
            ForEach(options) { option in
                AnswerButton(
                    title: "\(option.title) \(option.isCorrect ? "✅" : "")",
                    action: {}
                )
            }
        }
    }

}

struct AnswerButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, .spacing5)
                .padding(.horizontal, .spacing20)
        }
        #if !os(visionOS)
        .buttonStyle(.glassProminent)
        #endif
    }
}

#Preview("Ready") {
    PlotRemixGamePlayFeatureView(
        store: Store(
            initialState: PlotRemixGamePlayFeature.State(
                metadata: GameMetadata.mock,
                viewState: .ready(
                    .init(game: Game.mock)
                )
            ),
            reducer: {
                EmptyReducer()
            }
        )
    )
}

#Preview("Error") {
    PlotRemixGamePlayFeatureView(
        store: Store(
            initialState: PlotRemixGamePlayFeature.State(
                metadata: GameMetadata.mock,
                viewState: .error(ViewStateError(GenerateGameError.riddleGeneration()))
            ),
            reducer: {
                EmptyReducer()
            }
        )
    )
}
