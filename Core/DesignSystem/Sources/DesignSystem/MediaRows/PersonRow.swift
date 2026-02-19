//
//  PersonRow.swift
//  DesignSystem
//
//  Copyright © 2026 Adam Young.
//

import SwiftUI

/// A row component that displays a person with their profile image and name.
///
/// Use this component in lists or scroll views to display person information,
/// such as cast members, crew, or search results.
///
/// The row displays a circular profile image on the left with the person's name
/// to the right in a horizontal layout.
public struct PersonRow: View {

    /// The unique identifier of the person.
    public var id: Int

    /// The name of the person to display.
    public var name: String

    /// The URL of the person's profile image, if available.
    public var profileURL: URL?

    /// Creates a new person row.
    ///
    /// - Parameters:
    ///   - id: The unique identifier of the person.
    ///   - name: The name of the person to display.
    ///   - profileURL: The URL of the person's profile image. Defaults to `nil`.
    public init(
        id: Int,
        name: String,
        profileURL: URL? = nil
    ) {
        self.id = id
        self.name = name
        self.profileURL = profileURL
    }

    public var body: some View {
        HStack {
            ProfileImage(url: profileURL)
                .frame(width: 80, height: 80)
                .cornerRadius(40)
                .clipped()

            Text(verbatim: name)
        }
        .accessibilityElement(children: .combine)
    }

}

#Preview {
    NavigationStack {
        List {
            PersonRow(
                id: 500,
                name: "Tom Cruise",
                profileURL: URL(
                    string: "https://image.tmdb.org/t/p/w185/eOh4ubpOm2Igdg0QH2ghj0mFtC.jpg"
                )
            )

            PersonRow(
                id: 115_440,
                name: "Sydney Sweeney",
                profileURL: URL(
                    string: "https://image.tmdb.org/t/p/w185/uDnIdU4KGjQg7liFvb9wnALvg95.jpg"
                )
            )
        }
    }
}
