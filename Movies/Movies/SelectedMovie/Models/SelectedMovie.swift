//
//  SelectedMovieResponse.swift
//  Movies
//
//  Created by Petro Yurkiv on 04.06.2024.
//

import Foundation

struct SelectedMovie: Codable {
    let genres: [Genre]
    let id: Int
    let originCountry: [String]
    let overview: String
    let posterPath: String?
    let releaseDate: String
    let title: String
    let voteAverage: Double
    
    private enum CodingKeys: String, CodingKey {
        case genres
        case id
        case originCountry = "origin_country"
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case voteAverage = "vote_average"
    }
}
