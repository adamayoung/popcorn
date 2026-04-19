//
//  EPGSnapshotMapper.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVListingsDomain
import TVListingsInfrastructure

struct EPGSnapshotMapper {

    private let channelMapper = EPGChannelMapper()
    private let programmeMapper = EPGProgrammeMapper()

    ///
    /// Flattens the decoded EPG response into a domain snapshot.
    ///
    /// - Parameters:
    ///   - response: The decoded EPG response.
    ///   - referenceDate: Any programme whose `endTime` is at or before this date is
    ///     excluded from the snapshot. This keeps the persisted cache free of shows
    ///     that have already finished.
    ///
    func map(_ response: EPGResponseDTO, referenceDate: Date) -> TVListingsSnapshot {
        var channels: [TVChannel] = []
        channels.reserveCapacity(response.channels.count)

        var programmes: [TVProgramme] = []
        // Guards against duplicate programme IDs in the feed which would otherwise
        // violate `@Attribute(.unique)` on `TVProgrammeEntity.programmeID` and abort sync.
        var seenProgrammeIDs = Set<String>()

        for channelDTO in response.channels {
            let channel = channelMapper.map(channelDTO)
            channels.append(channel)

            for schedule in channelDTO.schedules {
                for programmeDTO in schedule.programmes {
                    let programme = programmeMapper.map(programmeDTO, channelID: channel.id)
                    guard programme.endTime > referenceDate else {
                        continue
                    }
                    guard seenProgrammeIDs.insert(programme.id).inserted else {
                        continue
                    }
                    programmes.append(programme)
                }
            }
        }

        return TVListingsSnapshot(channels: channels, programmes: programmes)
    }

}
