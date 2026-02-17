//
//  TVSeriesRow.swift
//  DesignSystem
//
//  Copyright © 2026 Adam Young.
//

import SwiftUI

/// A row component that displays a TV series with its poster image and name.
///
/// Use this component in lists or scroll views to display TV series information,
/// such as in search results, recommendations, or browsing collections.
///
/// The row displays a rectangular poster image on the left with the series name
/// to the right in a horizontal layout.
public struct TVSeriesRow: View {

    /// The unique identifier of the TV series.
    public var id: Int

    /// The name of the TV series to display.
    public var name: String

    /// The URL of the TV series poster image, if available.
    public var posterURL: URL?

    /// Creates a new TV series row.
    ///
    /// - Parameters:
    ///   - id: The unique identifier of the TV series.
    ///   - name: The name of the TV series to display.
    ///   - posterURL: The URL of the TV series poster image. Defaults to `nil`.
    public init(
        id: Int,
        name: String,
        posterURL: URL? = nil
    ) {
        self.id = id
        self.name = name
        self.posterURL = posterURL
    }

    public var body: some View {
        HStack {
            PosterImage(url: posterURL)
                .posterWidth(80)
                .cornerRadius(10)
                .clipped()

            Text(verbatim: name)
        }
    }

}

#Preview {
    NavigationStack {
        List {
            TVSeriesRow(
                id: 247_718,
                name: "MobLand",
                posterURL: URL(
                    string: "https://image.tmdb.org/t/p/w500/abeH7n5pcuQcwYcTxG6DTZvXLP1.jpg"
                )
            )

            TVSeriesRow(
                id: 100_088,
                name: "The Last of Us",
                posterURL: URL(
                    string: "https://image.tmdb.org/t/p/w500/dmo6TYuuJgaYinXBPjrgG9mB5od.jpg"
                )
            )
        }
    }
}
