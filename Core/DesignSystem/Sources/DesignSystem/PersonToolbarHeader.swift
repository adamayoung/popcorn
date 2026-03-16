//
//  PersonToolbarHeader.swift
//  DesignSystem
//
//  Copyright © 2026 Adam Young.
//

import SwiftUI

public struct PersonToolbarHeader: View {

    private let name: String
    private let profileURL: URL?
    private let initials: String?

    public init(name: String, profileURL: URL? = nil, initials: String? = nil) {
        self.name = name
        self.profileURL = profileURL
        self.initials = initials
    }

    public var body: some View {
        VStack(spacing: 0) {
            ProfileImage(url: profileURL, initials: initials)
                .frame(width: 50, height: 50)
                .clipShape(.circle)
                .zIndex(1)

            Text(verbatim: name)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .padding(.spacing8)
            #if !os(visionOS)
                .glassEffect(.regular, in: .capsule)
            #endif
                .offset(y: -.spacing5)
        }
        .font(.headline)
        .padding(.top, .spacing30)
    }

}

#Preview {
    let name = "Quentin Tarantino"
    let profileURL = URL(string: "https://image.tmdb.org/t/p/w185/1gjcpAa99FAOWGnrUvHEXXsRs7o.jpg")

    NavigationStack {
        List {}
            .navigationTitle(name)
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    ZStack {
                        Color.clear.frame(height: 0)
                        PersonToolbarHeader(
                            name: name,
                            profileURL: profileURL,
                            initials: "QT"
                        )
                        .transition(.opacity)
                    }
                }
            }
    }
}
