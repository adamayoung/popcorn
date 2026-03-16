//
//  TVSeasonToolbarHeader.swift
//  DesignSystem
//
//  Copyright © 2026 Adam Young.
//

import SwiftUI

public struct TVSeasonToolbarHeader: View {

    private let name: String
    private let tvSeriesName: String
    private let posterURL: URL?

    public init(
        name: String,
        tvSeriesName: String,
        posterURL: URL? = nil
    ) {
        self.name = name
        self.tvSeriesName = tvSeriesName
        self.posterURL = posterURL
    }

    public var body: some View {
        VStack(spacing: 0) {
            PosterImage(url: posterURL)
                .posterHeight(50)
                .zIndex(1)

            VStack(spacing: .spacing2) {
                Text(verbatim: name)
                    .font(.headline)

                Text(verbatim: tvSeriesName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.spacing8)
            #if !os(visionOS)
                .glassEffect(.regular, in: .capsule)
            #endif
                .offset(y: -.spacing5)
        }
        .padding(.top, .spacing50)
    }

}

#Preview {
    let name = "Stranger Things 5"
    let tvSeriesName = "Stranger Things"
    let posterURL = URL(string: "https://image.tmdb.org/t/p/w185/5i5Fg549J27knMvhI5NRM2FT3Gn.jpg")

    NavigationStack {
        List {}
            .navigationTitle(name)
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    ZStack {
                        Color.clear.frame(height: 0)
                        TVSeasonToolbarHeader(
                            name: name,
                            tvSeriesName: tvSeriesName,
                            posterURL: posterURL
                        )
                        .transition(.opacity)
                    }
                }
            }
    }
}
