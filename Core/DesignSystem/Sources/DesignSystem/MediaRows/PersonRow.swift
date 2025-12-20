//
//  PersonRow.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import SwiftUI

public struct PersonRow: View {

    public var id: Int
    public var name: String
    public var profileURL: URL?

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
