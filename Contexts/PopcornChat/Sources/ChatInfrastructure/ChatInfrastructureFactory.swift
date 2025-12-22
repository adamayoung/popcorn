//
//  ChatInfrastructureFactory.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import ChatDomain
import Foundation
import Observability

package final class ChatInfrastructureFactory {

    private let observability: any Observing

    package init(observability: some Observing) {
        self.observability = observability
    }

    package func makeChatSessionFactory() -> any ChatSessionFactory {
        DefaultChatSessionFactory(observability: observability)
    }

}
