//
//  UITestDependencies.swift
//  AppDependencies
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import ConfigurationUITesting
import DiscoverUITesting
import Foundation
import GamesCatalogUITesting
import GenresUITesting
import IntelligenceUITesting
import MoviesUITesting
import PeopleUITesting
import PlotRemixGameUITesting
import SearchUITesting
import TrendingUITesting
import TVSeriesUITesting

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
