//
//  MediaSearchGenresContentView.swift
//  MediaSearchFeature
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import DesignSystem
import Foundation
import SwiftUI

struct MediaSearchGenresContentView: View {

    let genres: [Genre]
    var onGenreTapped: (Genre) -> Void

    private static let columns = [
        GridItem(.flexible(), spacing: .spacing16),
        GridItem(.flexible(), spacing: .spacing16)
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: Self.columns, spacing: .spacing16) {
                ForEach(genres) { genre in
                    Button {
                        onGenreTapped(genre)
                    } label: {
                        GenreCardView(
                            name: genre.name,
                            color: Color(
                                red: genre.color.red,
                                green: genre.color.green,
                                blue: genre.color.blue
                            ),
                            imageURL: genre.backdropURL
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .contentMargins(.spacing20, for: .scrollContent)
    }

}

// MARK: - Previews

private let tmdbImageBase = "https://image.tmdb.org/t/p/w780"

#Preview("Genres") {
    NavigationStack {
        MediaSearchGenresContentView(
            genres: .previewData,
            onGenreTapped: { _ in }
        )
        .navigationTitle("Search")
    }
}

extension [Genre] {

    static var previewData: [Genre] {
        let data: [(id: Int, name: String, r: Double, g: Double, b: Double, backdrop: String)] = [
            (28, "Action", 1.0, 0.23, 0.19, "/dqK9Hag1054tghRQSqLSfrkvQnA.jpg"),
            (12, "Adventure", 1.0, 0.58, 0.0, "/2u7zbn8EudG6kLlBzUYqP8RyFU4.jpg"),
            (16, "Animation", 1.0, 0.8, 0.0, "/9xfDWXAUbFXQK585JvByT5pEAhe.jpg"),
            (35, "Comedy", 0.2, 0.78, 0.35, "/yDHYTfA3R0jFYba16jBB1ef8oIt.jpg"),
            (80, "Crime", 0.0, 0.78, 0.75, "/sdwjQEM869JFwMytTmvr6ggvaUl.jpg"),
            (99, "Documentary", 0.19, 0.67, 0.9, "/mDfJG3LC3Dqb67AZ52x3Z0jU0uB.jpg"),
            (18, "Drama", 0.0, 0.48, 1.0, "/8ZTVqvKDQ8emSGUEMjsS4yHAwrp.jpg"),
            (14, "Fantasy", 0.35, 0.34, 0.84, "/z51Wzj94hvAIsWfknifKTqKJRwp.jpg"),
            (27, "Horror", 0.69, 0.32, 0.87, "/tElnmtQ6yz1PjN1kePNl8yMSb59.jpg"),
            (10402, "Music", 1.0, 0.18, 0.33, "/kfXgo2rMF1A19celCwLyQ4Xwpf8.jpg"),
            (9648, "Mystery", 0.8, 0.2, 0.4, "/aJCtkxLLzkk1pECehVjKHA2lBgw.jpg"),
            (10749, "Romance", 0.6, 0.4, 0.2, "/7RyHsO4yDXtBv1zUU3mTpHeQ0d5.jpg")
        ]

        return data.map { item in
            Genre(
                id: item.id,
                name: item.name,
                color: ThemeColor(red: item.r, green: item.g, blue: item.b),
                backdropURL: URL(string: "\(tmdbImageBase)\(item.backdrop)")
            )
        }
    }

}
