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

    private static let toolbarHeaderScrollThreshold: CGFloat = 200
    private static let maxProfileSize: CGFloat = 300

    @State private var showToolbarHeader = false

    var body: some View {
        ScrollView {
            profileImage
                .frame(width: 300, height: 300)
                .clipShape(.circle)
                .overlay {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                }

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
        .onScrollGeometryChange(for: Bool.self) { geometry in
            geometry.contentOffset.y > Self.toolbarHeaderScrollThreshold
        } action: { _, shouldShow in
            if shouldShow != showToolbarHeader {
                withAnimation {
                    showToolbarHeader = shouldShow
                }
            }
        }
        .navigationTitle(person.name)
        #if os(iOS)
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    ZStack {
                        Color.clear.frame(height: 0)
                        if showToolbarHeader {
                            PersonToolbarHeader(
                                name: person.name,
                                profileURL: person.smallProfileURL,
                                initials: person.initials
                            )
                            .transition(.opacity)
                        }
                    }
                }
            }
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
