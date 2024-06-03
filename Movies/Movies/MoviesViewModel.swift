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
    private let posterService: PosterNetworkServiceProtocol
    private var movies: [Movie] = []
    var selectedMovieCategory: MovieCategory = .popular
    var onLoadSuccess: (([Movie]) -> Void)?
    
    init(networkService: MoviesNetworkServiceProtocol, posterService: PosterNetworkServiceProtocol) {
        self.networkService = networkService
        self.posterService = posterService
    }
    
    func fetch(search: String, page: Int) {
        if search.isEmpty {
            networkService.fetchMovies(category: selectedMovieCategory, page: page) { [weak self] result in
                self?.parseResult(page: page, result: result)
            }
        } else {
            networkService.searchMovies(search: search, page: page) { [weak self] result in
                self?.parseResult(page: page, result: result)
            }
        }
    }
    
    private func parseResult(page: Int, result: Result<MoviesResponse, Error>) {
        switch result {
        case .success(let success):
            if page == 1 {
                movies = success.results
                onLoadSuccess?(movies)
            } else {
                movies.append(contentsOf: success.results)
                onLoadSuccess?(movies)
            }
        case .failure(let failure):
            print("failure")
        }
    }

    func getPoster(posterPath: String, completion: @escaping (Result<Data, Error>) -> Void) {
        posterService.getPosterData(posterPath: posterPath) { result in
            switch result {
            case .success(let success):
                completion(.success(success))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
}
