//
//  AnyEncodable.swift
//  Caching
//
//  Copyright © 2026 Adam Young.
//

import Foundation

struct AnyEncodable: Encodable {

    private let encodeFunc: (Encoder) throws -> Void

    init(_ wrapped: some Encodable) {
        self.encodeFunc = wrapped.encode
    }

    func encode(to encoder: Encoder) throws {
        try encodeFunc(encoder)
    }

}
