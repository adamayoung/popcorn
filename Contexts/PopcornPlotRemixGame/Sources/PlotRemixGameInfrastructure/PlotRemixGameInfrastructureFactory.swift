//
//  PlotRemixGameInfrastructureFactory.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Observability
import PlotRemixGameDomain

package final class PlotRemixGameInfrastructureFactory {

    private let observability: any Observing

    package init(observability: some Observing) {
        self.observability = observability
    }

    package func makeSynopsisRiddleGenerator() -> some SynopsisRiddleGenerating {
        FoundationModelsSynopsisRiddleGenerator(
            observability: observability
        )
    }

}
