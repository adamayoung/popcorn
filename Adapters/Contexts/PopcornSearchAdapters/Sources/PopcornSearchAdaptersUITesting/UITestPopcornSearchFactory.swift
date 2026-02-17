//
//  UITestPopcornSearchFactory.swift
//  PopcornSearchAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SearchApplication
import SearchComposition
import SearchDomain

public final class UITestPopcornSearchFactory: PopcornSearchFactory {

    private let applicationFactory: SearchApplicationFactory

    public init() {
        self.applicationFactory = SearchApplicationFactory(
            mediaRepository: StubMediaRepository(),
            appConfigurationProvider: StubAppConfigurationProvider(),
            mediaProvider: StubMediaProvider()
        )
    }

    public func makeSearchMediaUseCase() -> SearchMediaUseCase {
        applicationFactory.makeSearchMediaUseCase()
    }

    public func makeFetchMediaSearchHistory() -> FetchMediaSearchHistoryUseCase {
        applicationFactory.makeFetchMediaSearchHistory()
    }

    public func makeAddMediaSearchHistoryEntryUseCase() -> AddMediaSearchHistoryEntryUseCase {
        applicationFactory.makeAddMediaSearchHistoryEntryUseCase()
    }

}
