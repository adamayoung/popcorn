//
//  ToolbarHeader.swift
//  MovieDetailsFeature
//
//  Created by Adam Young on 02/03/2026.
//

import DesignSystem
import SwiftUI

struct ToolbarHeader: View {

    var title: String
    var posterURL: URL?

    var body: some View {
        VStack(spacing: 0) {
            PosterImage(url: posterURL)
                .posterHeight(50)
                .zIndex(1)

            Text(verbatim: title)
                .padding(8)
                .glassEffect(.regular, in: .capsule)
                .offset(y: -5)
        }
        .font(.headline)
        .padding(.top, 30)
    }

}
