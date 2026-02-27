//
//  PersonDetailsContentView.swift
//  PersonDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import SwiftUI

struct PersonDetailsContentView: View {

    var person: Person
    var isFocalPointEnabled: Bool

    private static let maxProfileSize: CGFloat = 300

    var body: some View {
        ScrollView {
            GeometryReader { proxy in
                let size = min(proxy.size.width * 0.65, Self.maxProfileSize)
                profileImage
                    .frame(width: size, height: size)
                    .clipShape(.circle)
                    .overlay {
                        Circle()
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    }
                    .frame(maxWidth: .infinity)
            }
            .frame(height: Self.maxProfileSize)

            VStack {
                Text(verbatim: person.name)
                    .font(.title)
                    .padding(.bottom)

                Text(verbatim: person.biography)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .navigationTitle(person.name)
        #if os(iOS)
            .hideToolbarTitle()
        #endif
    }

}

extension PersonDetailsContentView {

    @ViewBuilder
    private var profileImage: some View {
        let image = ProfileImage(url: person.profileURL, initials: person.initials)
        if isFocalPointEnabled {
            image.focalPointAlignment()
        } else {
            image
        }
    }

}

#Preview {
    NavigationStack {
        PersonDetailsContentView(person: Person.mock, isFocalPointEnabled: true)
    }
}
