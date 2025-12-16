//
//  TMDbClient+TCA.swift
//  AppDependencies
//
//  Created by Adam Young on 18/11/2025.
//

import ComposableArchitecture
import Foundation
import TMDb

enum TMDbClientKey: DependencyKey {

    static let liveValue = TMDbClient(apiKey: TMDbAPIKeyProvider.apiKey())
    static let testValue = TMDbClient(apiKey: "test_tmdb_api_key")
    static let previewValue = TMDbClient(apiKey: "preview_tmdb_api_key")

}

extension DependencyValues {

    var tmdb: TMDbClient {
        get { self[TMDbClientKey.self] }
        set { self[TMDbClientKey.self] = newValue }
    }

}
