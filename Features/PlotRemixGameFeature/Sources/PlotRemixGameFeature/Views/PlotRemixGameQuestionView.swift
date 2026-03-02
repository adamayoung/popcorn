//
//  PlotRemixGameQuestionView.swift
//  PlotRemixGameFeature
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import SwiftUI

struct PlotRemixGameQuestionView: View {

    var question: GameQuestion

    var body: some View {
        VStack(spacing: .spacing50) {
            Spacer()

            Text(verbatim: "\(question.riddle)")

            Spacer()

            GlassEffectContainer(spacing: .spacing16) {
                VStack(spacing: .spacing16) {
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

// #Preview {
//    PlotRemixGameQuestionView()
// }
