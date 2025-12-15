//
//  PlotRemixGameQuestionsView.swift
//  PlotRemixGameFeature
//
//  Created by Adam Young on 12/12/2025.
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
//#Preview {
//    PlotRemixGameQuestionsView()
//}
