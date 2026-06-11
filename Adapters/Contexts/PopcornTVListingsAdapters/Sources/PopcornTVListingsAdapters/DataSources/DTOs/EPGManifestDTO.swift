//
//  EPGManifestDTO.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

struct EPGManifestDTO: Decodable {

    let generatedAt: String
    let dates: [String]
    let files: [EPGManifestFileDTO]

}

struct EPGManifestFileDTO: Decodable {

    let path: String
    let hash: String
    let bytes: Int

}
