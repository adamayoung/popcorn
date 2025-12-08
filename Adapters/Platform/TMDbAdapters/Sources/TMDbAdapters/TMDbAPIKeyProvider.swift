//
//  TMDbAPIKeyProvider.swift
//  TMDbAdapters
//
//  Created by Adam Young on 05/12/2025.
//

import Foundation

enum TMDbAPIKeyProvider {

    static func apiKey(
        environment: [String: String] = ProcessInfo.processInfo.environment,
        bundle: Bundle = .main
    ) -> String {
        if let env = environment["TMDB_API_KEY"],
            !env.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        {
            return env
        }

        if let value = bundle.object(forInfoDictionaryKey: "TMDbAPIKey") as? String,
            !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        {
            return value
        }

        fatalError("Missing TMDB_API_KEY. Provide via environment variable or Info.plist value.")
    }

}
