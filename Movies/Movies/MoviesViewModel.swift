//
//  MoviesViewModel.swift
//  Movies
//
//  Created by Petro Yurkiv on 30.05.2024.
//

import Foundation

class MoviesViewModel {
    weak var coordinator: MoviesCoordinator?
    private let networkService: MoviesNetworkServiceProtocol
    
    init(networkService: MoviesNetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func getMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        networkService.fetchMovies(category: .nowPlaying, page: 1) { [weak self] result in
            switch result {
            case .success(let success):
                completion(.success(success.results))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
    
    func getPoster(posterPath: String, completion: @escaping (Result<Data, Error>) -> Void) {
        networkService.getPosterData(posterPath: posterPath) { [weak self] result in
            switch result {
            case .success(let success):
                completion(.success(success))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
}
