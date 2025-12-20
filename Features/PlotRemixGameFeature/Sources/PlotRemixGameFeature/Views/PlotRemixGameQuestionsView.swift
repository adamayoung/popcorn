//
//  PlotRemixGameQuestionsView.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
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
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
}

//
// #Preview {
//    PlotRemixGameQuestionsView()
// }
