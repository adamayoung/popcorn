//
//  PlotRemixGamePlayFeatureView.swift
//  PlotRemixGameFeature
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct PlotRemixGamePlayFeatureView: View {

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
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

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

                case .error:
                    ContentUnavailableView(
                        LocalizedStringResource("GAME_CANNOT_BE_GENERATED", bundle: .module),
                        systemImage: "exclamationmark.triangle.fill",
                        description: Text(
                            "THERE_WAS_A_PROBLEM_WHILE_GENERATING_THE_GAME_TRY_AGAIN",
                            bundle: .module
                        )
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
                ToolbarItem(placement: .topBarLeading) {
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
            .animation(.easeIn(duration: 3), value: progress)
        }
    }

    private func content(game: Game) -> some View {
        ForEach(game.questions) { question in
            VStack(spacing: 50) {
                Spacer()

                Text(verbatim: "\(question.riddle)")

                Spacer()

                GlassEffectContainer(spacing: 16) {
                    VStack(spacing: 16) {
                        ForEach(question.options) { option in
                            AnswerButton(
                                title: "\(option.title) \(option.isCorrect ? "✅" : "")",
                                action: {}
                            )
                        }
                    }
                }
            }
            .padding()
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
                .padding(.vertical, 5)
                .padding(.horizontal, 20)
        }
        .buttonStyle(.glassProminent)
    }
}

#Preview {
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
