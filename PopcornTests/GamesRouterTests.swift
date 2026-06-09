//
//  GamesRouterTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

@testable import Popcorn
import Testing

@MainActor
@Suite("GamesRouter Tests")
struct GamesRouterTests {

    @Test("openGame(id: 1) presents the Plot Remix game")
    func openGameOnePresentsGame() {
        let router = GamesRouter()
        let navigator = GamesRouterNavigator(router: router)

        navigator.openGame(id: 1)

        #expect(router.presentedGame?.gameID == 1)
    }

    @Test("openGame with an unmapped id leaves nothing presented")
    func openGameOtherIDIsNoOp() {
        let router = GamesRouter()
        let navigator = GamesRouterNavigator(router: router)

        navigator.openGame(id: 2)

        #expect(router.presentedGame == nil)
    }

    @Test("dismiss clears the presented game")
    func dismissClearsPresentedGame() {
        let router = GamesRouter(presentedGame: .init(gameID: 1))
        let navigator = GamesRouterNavigator(router: router)

        navigator.dismiss()

        #expect(router.presentedGame == nil)
    }

}
