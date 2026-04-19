//
//  TVChannelRepository.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Provides read access to the locally cached list of TV channels.
///
public protocol TVChannelRepository: Sendable {

    func channels() async throws(TVListingsRepositoryError) -> [TVChannel]

}
