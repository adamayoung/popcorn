//
//  PlotRemixGameQuestionView.swift
//  PlotRemixGameFeature
//
//  Copyright © 2025 Adam Young.
//

import SwiftUI

struct PlotRemixGameQuestionView: View {

    var question: GameQuestion

    var body: some View {
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

// #Preview {
//    PlotRemixGameQuestionView()
// }
