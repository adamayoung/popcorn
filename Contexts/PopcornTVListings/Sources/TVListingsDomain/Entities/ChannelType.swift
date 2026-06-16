//
//  ChannelType.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// The kind of service a ``Channel`` carries. The EPG feed publishes `"tv"` or `"radio"`;
/// the TV listings show only ``television`` channels.
///
public enum ChannelType: String, Equatable, Sendable {

    case television = "tv"
    case radio

}
