//
//  GenreCardView.swift
//  MediaSearchFeature
//
//  Copyright © 2026 Adam Young.
//

import SDWebImageSwiftUI
import SwiftUI

struct GenreCardView: View {

    let name: String
    let color: Color
    let imageURL: URL?

    var body: some View {
        color
            .frame(height: 110)
            .overlay {
                WebImage(url: imageURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .saturation(0)
                        .blendMode(.multiply)
                } placeholder: {
                    EmptyView()
                }
            }
            .overlay {
                LinearGradient(
                    colors: [color.opacity(0.8), .clear],
                    startPoint: .bottom,
                    endPoint: .center
                )
            }
            .overlay(alignment: .bottomLeading) {
                Text(name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                    .padding(10)
            }
            .clipShape(.rect(cornerRadius: 10))
    }

}

// MARK: - Previews

private let tmdbImageBase = "https://image.tmdb.org/t/p/w780"

#Preview("Action") {
    GenreCardView(
        name: "Action",
        color: Color(red: 1.0, green: 0.23, blue: 0.19),
        imageURL: URL(string: "\(tmdbImageBase)/dqK9Hag1054tghRQSqLSfrkvQnA.jpg")
    )
    .padding()
}

#Preview("Grid") {
    GenreGridPreview()
}

private struct GenreGridPreview: View {

    private let genres: [(id: Int, name: String, color: Color, backdrop: String)] = [
        (28, "Action", Color(red: 1.0, green: 0.23, blue: 0.19), "/dqK9Hag1054tghRQSqLSfrkvQnA.jpg"),
        (12, "Adventure", Color(red: 1.0, green: 0.58, blue: 0.0), "/2u7zbn8EudG6kLlBzUYqP8RyFU4.jpg"),
        (16, "Animation", Color(red: 1.0, green: 0.8, blue: 0.0), "/9xfDWXAUbFXQK585JvByT5pEAhe.jpg"),
        (35, "Comedy", Color(red: 0.2, green: 0.78, blue: 0.35), "/yDHYTfA3R0jFYba16jBB1ef8oIt.jpg"),
        (80, "Crime", Color(red: 0.0, green: 0.78, blue: 0.75), "/sdwjQEM869JFwMytTmvr6ggvaUl.jpg"),
        (99, "Documentary", Color(red: 0.19, green: 0.67, blue: 0.9), "/mDfJG3LC3Dqb67AZ52x3Z0jU0uB.jpg"),
        (18, "Drama", Color(red: 0.0, green: 0.48, blue: 1.0), "/8ZTVqvKDQ8emSGUEMjsS4yHAwrp.jpg"),
        (14, "Fantasy", Color(red: 0.35, green: 0.34, blue: 0.84), "/z51Wzj94hvAIsWfknifKTqKJRwp.jpg"),
        (27, "Horror", Color(red: 0.69, green: 0.32, blue: 0.87), "/tElnmtQ6yz1PjN1kePNl8yMSb59.jpg"),
        (10402, "Music", Color(red: 1.0, green: 0.18, blue: 0.33), "/kfXgo2rMF1A19celCwLyQ4Xwpf8.jpg"),
        (9648, "Mystery", Color(red: 0.8, green: 0.2, blue: 0.4), "/aJCtkxLLzkk1pECehVjKHA2lBgw.jpg"),
        (10749, "Romance", Color(red: 0.6, green: 0.4, blue: 0.2), "/7RyHsO4yDXtBv1zUU3mTpHeQ0d5.jpg")
    ]

    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(genres, id: \.id) { genre in
                        GenreCardView(
                            name: genre.name,
                            color: genre.color,
                            imageURL: URL(string: "\(tmdbImageBase)\(genre.backdrop)")
                        )
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle(Text(verbatim: "Search"))
        }
    }

}
