//
//  NowPlayhead.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import SwiftUI

/// The vertical "now" rule that rides the body content at the current time's
/// x-offset. Purely decorative and non-interactive.
struct NowPlayhead: View {

    let height: CGFloat

    var body: some View {
        Rectangle()
            .fill(Color.accentColor)
            .frame(width: 2, height: height)
            .allowsHitTesting(false)
            .accessibilityHidden(true)
    }

}
