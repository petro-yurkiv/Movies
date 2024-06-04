//
//  MovieCategory.swift
//  Movies
//
//  Created by Petro Yurkiv on 30.05.2024.
//

import Foundation

enum MovieCategory: CaseIterable {
    case nowPlaying
    case popular
    case topRated
    case upcoming
    case search
    
    var name: String {
        switch self {
        case .nowPlaying:
            return "Now playing"
        case .popular:
            return "Popular"
        case .topRated:
            return "Top rated"
        case .upcoming:
            return "Upcoming"
        case .search:
            return ""
        }
    }
    
    var baseURL: String {
        switch self {
        case .nowPlaying:
            return "https://api.themoviedb.org/3/movie/now_playing"
        case .popular:
            return "https://api.themoviedb.org/3/movie/popular"
        case .topRated:
            return "https://api.themoviedb.org/3/movie/top_rated"
        case .upcoming:
            return "https://api.themoviedb.org/3/movie/upcoming"
        case .search:
            return "https://api.themoviedb.org/3/search/movie"
        }
    }
}
