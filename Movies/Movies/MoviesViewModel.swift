//
//  MoviesViewModel.swift
//  Movies
//
//  Created by Petro Yurkiv on 30.05.2024.
//

import Foundation

class MoviesViewModel {
    weak var coordinator: MoviesCoordinator?
    var networkService: MoviesNetworkServiceProtocol
    
    init(networkService: MoviesNetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func getMovies() {
        networkService.fetchMovies(category: .nowPlaying) { result in
            print(result)
        }
    }
}
