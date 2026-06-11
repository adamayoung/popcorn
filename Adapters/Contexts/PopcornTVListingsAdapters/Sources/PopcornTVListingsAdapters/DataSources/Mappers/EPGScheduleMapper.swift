//
//  EPGScheduleMapper.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain

struct EPGScheduleMapper {

    private let programmeMapper = EPGProgrammeMapper()

    ///
    /// Flattens a day's schedule (channels → programmes) into domain programmes.
    /// Deduplicates by programme ID within the file, guarding against duplicates that
    /// would otherwise violate `@Attribute(.unique)` on `TVProgrammeEntity.programmeID`.
    ///
    func map(_ dto: EPGScheduleResponseDTO) -> [TVProgramme] {
        var programmes: [TVProgramme] = []
        var seenProgrammeIDs = Set<String>()

        for channel in dto.channels {
            for programmeDTO in channel.programmes {
                let programme = programmeMapper.map(programmeDTO, channelID: channel.sid)
                guard seenProgrammeIDs.insert(programme.id).inserted else {
                    continue
                }
                programmes.append(programme)
            }
        }

        return programmes
    }

}
