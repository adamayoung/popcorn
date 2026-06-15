//
//  TVRegion.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A Sky region, identified by a `(bouquet, subBouquet)` pair. The bouquet encodes the
/// nation-group and resolution; the subBouquet the area within it. The same area appears
/// once per resolution (an HD bouquet and an SD bouquet), so ``isHD`` distinguishes them.
///
public struct TVRegion: Identifiable, Equatable, Sendable {

    public let bouquet: Int

    public let subBouquet: Int

    public let name: String

    public let nation: String

    public let isHD: Bool

    /// Stable identity derived from the `(bouquet, subBouquet)` pair.
    public var id: String {
        "\(bouquet)-\(subBouquet)"
    }

    public init(bouquet: Int, subBouquet: Int, name: String, nation: String, isHD: Bool) {
        self.bouquet = bouquet
        self.subBouquet = subBouquet
        self.name = name
        self.nation = nation
        self.isHD = isHD
    }

}
