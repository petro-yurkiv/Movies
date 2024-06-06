//
//  MovieTrailerResponse.swift
//  Movies
//
//  Created by Petro Yurkiv on 05.06.2024.
//

import Foundation

struct MovieTrailerResponse: Codable {
    let results: [MovieTrailer]
}

struct MovieTrailer: Codable {
    let key: String
}
