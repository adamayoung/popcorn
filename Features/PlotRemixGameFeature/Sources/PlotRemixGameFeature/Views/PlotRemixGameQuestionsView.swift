//
//  PlotRemixGameQuestionsView.swift
//  PlotRemixGameFeature
//
//  Copyright © 2026 Adam Young.
//

import SwiftUI

struct PlotRemixGameQuestionsView: View {

    var questions: [GameQuestion]

    var body: some View {
        TabView {
            ForEach(questions) { question in
                Tab {
                    PlotRemixGameQuestionView(question: question)
                }
            }
        }
        #if os(iOS)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        #endif
    }
}

//
// #Preview {
//    PlotRemixGameQuestionsView()
// }
