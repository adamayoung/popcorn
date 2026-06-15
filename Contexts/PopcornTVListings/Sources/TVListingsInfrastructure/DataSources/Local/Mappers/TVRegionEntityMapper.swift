//
//  TVRegionEntityMapper.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain

struct TVRegionEntityMapper {

    func map(_ entity: TVRegionEntity) -> TVRegion {
        TVRegion(
            bouquet: entity.bouquet,
            subBouquet: entity.subBouquet,
            name: entity.name,
            nation: entity.nation,
            isHD: entity.isHD
        )
    }

    func map(_ region: TVRegion) -> TVRegionEntity {
        TVRegionEntity(
            bouquet: region.bouquet,
            subBouquet: region.subBouquet,
            name: region.name,
            nation: region.nation,
            isHD: region.isHD
        )
    }

}
