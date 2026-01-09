//
//  UITestDependencies.swift
//  AppDependencies
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import Foundation
import PopcornConfigurationAdaptersUITesting
import PopcornDiscoverAdaptersUITesting
import PopcornGamesCatalogAdaptersUITesting
import PopcornGenresAdaptersUITesting
import PopcornIntelligenceAdaptersUITesting
import PopcornMoviesAdaptersUITesting
import PopcornPeopleAdaptersUITesting
import PopcornPlotRemixGameAdaptersUITesting
import PopcornSearchAdaptersUITesting
import PopcornTrendingAdaptersUITesting
import PopcornTVSeriesAdaptersUITesting

public enum UITestDependencies {

    public static func configure(_ dependencies: inout DependencyValues) {
        dependencies.configurationFactory = UITestPopcornConfigurationFactory()
        dependencies.discoverFactory = UITestPopcornDiscoverFactory()
        dependencies.gamesCatalogFactory = UITestPopcornGamesCatalogFactory()
        dependencies.genresFactory = UITestPopcornGenresFactory()
        dependencies.intelligenceFactory = UITestPopcornIntelligenceFactory()
        dependencies.moviesFactory = UITestPopcornMoviesFactory()
        dependencies.peopleFactory = UITestPopcornPeopleFactory()
        dependencies.plotRemixGameFactory = UITestPopcornPlotRemixGameFactory()
        dependencies.searchFactory = UITestPopcornSearchFactory()
        dependencies.trendingFactory = UITestPopcornTrendingFactory()
        dependencies.tvSeriesFactory = UITestPopcornTVSeriesFactory()
    }

}
