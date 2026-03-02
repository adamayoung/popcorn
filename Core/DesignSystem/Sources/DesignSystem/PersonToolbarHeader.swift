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
                .padding(8)
                .glassEffect(.regular, in: .capsule)
                .offset(y: -5)
        }
        .font(.headline)
        .padding(.top, 30)
    }

}
