//
//  PlotRemixGameQuestionView.swift
//  PlotRemixGameFeature
//
//  Created by Adam Young on 12/12/2025.
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
                            action: {
                            })
                    }
                }
            }
        }
        .padding()
    }
}

//#Preview {
//    PlotRemixGameQuestionView()
//}
