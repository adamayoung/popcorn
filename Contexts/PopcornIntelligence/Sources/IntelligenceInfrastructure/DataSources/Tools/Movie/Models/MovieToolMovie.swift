//
//  MovieToolMovie.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import FoundationModels

@Generable
struct MovieToolMovie: PromptRepresentable, Equatable {
    @Guide(description: "This is the ID of the movie.")
    let id: Int
    @Guide(description: "This is the title of the movie.")
    let title: String
    @Guide(description: "This is the tagline of the movie.")
    let tagline: String?
    @Guide(description: "This is the original title of the movie.")
    let originalTitle: String?
    @Guide(description: "This is the original language of the movie.")
    let originalLanguage: String?
    @Guide(description: "This is an overview of the movie.")
    let overview: String
    @Guide(description: "This is the runtime in minutes.")
    let runtime: Int?
    @Guide(description: "This is the list of genres of the movie.")
    let genres: [MovieToolGenre]?
    @Guide(description: "This is the release date of the movie.")
    let releaseDate: String?
    @Guide(description: "This is the poster URL of the movie.")
    let posterPath: String?
    @Guide(description: "This is the backdrop URL of the movie.")
    let backdropPath: String?
    @Guide(description: "This is the production budget of the movie in USD.")
    let budget: Int?
    @Guide(description: "This is the box office revenue of the movie in USD.")
    let revenue: Int?
    @Guide(description: "This is the homepage URL of the movie.")
    let homepageURL: String?
    @Guide(description: "This is the IMDb ID of the movie.")
    let imdbID: String?
    @Guide(description: "This is the release status of the movie.")
    let status: String?
    @Guide(description: "This is the list of production companies of the movie.")
    let productionCompanies: [MovieToolProductionCompany]?
    @Guide(description: "This is the list of production countries of the movie.")
    let productionCountries: [MovieToolProductionCountry]?
    @Guide(description: "This is the list of spoken languages in the movie.")
    let spokenLanguages: [MovieToolSpokenLanguage]?
    @Guide(description: "This is the list of origin countries for the movie.")
    let originCountry: [String]?
    @Guide(description: "This is the movie collection the movie belongs to.")
    let belongsToCollection: MovieToolMovieCollection?
    @Guide(description: "This is the popularity score of the movie.")
    let popularity: Double?
    @Guide(description: "This is the average vote score of the movie.")
    let voteAverage: Double?
    @Guide(description: "This is the total vote count of the movie.")
    let voteCount: Int?
    @Guide(description: "Indicates whether the movie has a video.")
    let hasVideo: Bool?
    @Guide(description: "Indicates whether the movie is adult only.")
    let isAdultOnly: Bool?
}
