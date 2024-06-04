//
//  GenresResponse.swift
//  Movies
//
//  Created by Petro Yurkiv on 03.06.2024.
//

import Foundation

struct GenresResponse: Codable {
    let genres: [Genre]
}

struct Genre: Codable {
    let id: Int
    let name: String
}
