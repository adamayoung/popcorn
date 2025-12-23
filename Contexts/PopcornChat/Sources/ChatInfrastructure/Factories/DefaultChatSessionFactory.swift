//
//  DefaultChatSessionFactory.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import ChatDomain
import Foundation
import Observability

final class DefaultChatSessionFactory: ChatSessionFactory {

    private let observability: any Observing

    init(observability: some Observing) {
        self.observability = observability
    }

    func makeSession(
        tools: [any Sendable],
        instructions: String
    ) -> any ChatSessionManaging {
        FoundationModelsChatSession(
            tools: tools,
            instructions: instructions,
            observability: observability
        )
    }

}
