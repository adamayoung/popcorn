//
//  PlotRemixGameInfrastructureFactory.swift
//  PopcornPlotRemixGame
//
//  Created by Adam Young on 10/12/2025.
//

import Foundation
import PlotRemixGameDomain

package final class PlotRemixGameInfrastructureFactory {

    package init() {}

    package func makeSynopsisRiddleGenerator() -> some SynopsisRiddleGenerating {
        FoundationModelsSynopsisRiddleGenerator()
    }

}
