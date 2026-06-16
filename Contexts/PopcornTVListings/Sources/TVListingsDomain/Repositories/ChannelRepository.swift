//
//  ChannelRepository.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Provides read access to the locally cached list of TV channels.
///
public protocol ChannelRepository: Sendable {

    func channels() async throws(TVListingsRepositoryError) -> [Channel]

}
