//
//  PlotRemixGameInfrastructureFactory.swift
//  PopcornPlotRemixGame
//
//  Created by Adam Young on 10/12/2025.
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
