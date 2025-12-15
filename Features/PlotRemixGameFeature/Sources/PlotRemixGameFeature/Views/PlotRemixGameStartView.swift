//
//  PlotRemixGameStartView.swift
//  PlotRemixGameFeature
//
//  Created by Adam Young on 12/12/2025.
//

import SwiftUI
import DesignSystem

struct PlotRemixGameStartView: View {

    var metadata: GameMetadata
    var progress: Float? = nil
    var startGameAction: () -> Void

    var body: some View {
        VStack(spacing: 50) {
            VStack {
                Image(systemName: metadata.iconSystemName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)

                Text(verbatim: metadata.name)
                    .font(.largeTitle)
                    .bold()
            }

            Text(verbatim: metadata.description)

            Group {
                if let progress {
                    loadingView(progress: progress)
                } else {

                    Button {
                        startGameAction()
                    } label: {
                        Label(
                            LocalizedStringResource("START", bundle: .module),
                            systemImage: "play.fill"
                        )
                        .bold()
                        .labelStyle(.iconOnly)
                        .buttonStyle(.glass)
                        .padding()
                    }
                }
            }
            .frame(width: 30, height: 30)
        }
    }

    private func loadingView(progress: Float) -> some View {
        TimelineView(.animation(minimumInterval: 1.0 / 60.0)) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate

            VStack(spacing: 20) {
                ZStack {
                    // Background circle
                    Circle()
                        .stroke(Color.white.opacity(0.2), lineWidth: 4)
                        .frame(width: 100, height: 100)

                    // Progress ring
                    Circle()
                        .trim(from: 0, to: CGFloat(progress))
                        .stroke(
                            Color.white,
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .frame(width: 100, height: 100)
                        .rotationEffect(.degrees(-90))

                    // Spinning gradient overlay
                    Circle()
                        .trim(from: 0, to: 0.1)
                        .stroke(
                            AngularGradient(
                                colors: [Color.white, Color.white.opacity(0)],
                                center: .center
                            ),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .frame(width: 100, height: 100)
                        .rotationEffect(.degrees(time * 120))

                    // Icon with pulse
                    Image(systemName: metadata.iconSystemName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .foregroundStyle(Color.white)
                        .scaleEffect(1.0 + sin(time * 2) * 0.1)
                }

                // Progress percentage
                Text(verbatim: "\(Int(progress * 100))%")
                    .font(.title2)
                    .bold()
                    .foregroundStyle(Color.white)
                    .monospacedDigit()
            }
        }
        .animation(.easeInOut(duration: 0.3), value: progress)
    }

}

#Preview("Start") {
    let metadata = GameMetadata.mock

    NavigationStack {
        PlotRemixGameStartView(
            metadata: metadata,
            progress: nil,
            startGameAction: {}
        )

        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            AnimatedMeshBackground(baseColor: metadata.color)
                .ignoresSafeArea()
        }
    }
    .preferredColorScheme(.dark)
}

#Preview("Generating") {
    let metadata = GameMetadata.mock

    NavigationStack {
        PlotRemixGameStartView(
            metadata: metadata,
            progress: 0.50,
            startGameAction: {}
        )

        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            AnimatedMeshBackground(baseColor: metadata.color)
                .ignoresSafeArea()
        }
    }
    .preferredColorScheme(.dark)
}
