//
//  MoviesViewModel.swift
//  Movies
//
//  Created by Petro Yurkiv on 30.05.2024.
//

import Foundation

final class MoviesViewModel {
    weak var coordinator: MoviesCoordinator?
    
    private let networkService: MoviesNetworkServiceProtocol
    private let posterService: PosterNetworkServiceProtocol
    private let genresService: GenresNetworkServiceProtocol
    
    private var movies: [Movie] = []
    var genres: [Genre] = []
    var selectedMovieCategory: MovieCategory = .popular
    var onLoadSuccess: (([Movie]) -> Void)?
    
    init(networkService: MoviesNetworkServiceProtocol, posterService: PosterNetworkServiceProtocol, genresService: GenresNetworkServiceProtocol) {
        self.networkService = networkService
        self.posterService = posterService
        self.genresService = genresService
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
                mapGenresForMovies()
            } else {
                movies.append(contentsOf: success.results)
                mapGenresForMovies()
            }
        case .failure(let failure):
            print("failure")
        }
    }
    
    func getGenres() {
        genresService.fetchGenres { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                self.genres = success.genres
            case .failure(let failure):
                print("failure")
            }
        }
    }
    
    private func mapGenresForMovies() {
        movies = movies.map { movie in
            var updatedMovie = movie
            
            let genresForMovie = movie.genreIds.compactMap { id in
                return genres.first { $0.id == id }
            }
            
            updatedMovie.genres = genresForMovie
            return updatedMovie
        }
        
        onLoadSuccess?(movies)
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
