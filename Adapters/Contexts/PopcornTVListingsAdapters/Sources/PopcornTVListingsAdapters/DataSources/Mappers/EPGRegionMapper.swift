//
//  EPGRegionMapper.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain

struct EPGRegionMapper {

    func map(_ dto: EPGRegionDTO) -> TVRegion {
        TVRegion(
            bouquet: dto.bouquet,
            subBouquet: dto.subBouquet,
            name: dto.name,
            nation: dto.nation,
            isHD: dto.isHD
        )
    }

}
