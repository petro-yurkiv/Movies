//
//  Movies.swift
//  Movies
//
//  Created by Petro Yurkiv on 30.05.2024.
//

import Foundation

struct MoviesResponse: Codable {
    let page: Int
    let results: [Movie]
}

struct Movie: Codable {
    let id: Int
    let title: String
    let overview: String
    let releaseDate: String
    let posterPath: String?
    let backdropPath: String?
    let genreIds: [Int]
    let originalLanguage: String
    let adult: Bool
    let popularity: Double
    let voteAverage: Double
    let voteCount: Int
    let video: Bool

    private enum CodingKeys: String, CodingKey {
        case id, title, overview
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case originalLanguage = "original_language"
        case adult, popularity
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case video
    }
}
