//
//  MoviesViewModel.swift
//  Movies
//
//  Created by Petro Yurkiv on 30.05.2024.
//

import Foundation

final class MoviesViewModel {
    weak var coordinator: MoviesCoordinator?
    
    private let moviesService: MoviesNetworkServiceProtocol
    private let posterService: PosterNetworkServiceProtocol
    private let genresService: GenresNetworkServiceProtocol
    
    private var movies: [Movie] = []
    private var genres: [Genre] = []
    var selectedMovieCategory: MovieCategory = .nowPlaying
    
    var onLoading: ((Bool) -> Void)?
    var onLoadSuccess: (([Movie]) -> Void)?
    
    init(networkService: MoviesNetworkServiceProtocol, posterService: PosterNetworkServiceProtocol, genresService: GenresNetworkServiceProtocol) {
        self.moviesService = networkService
        self.posterService = posterService
        self.genresService = genresService
    }
    
    func fetch(search: String, page: Int) {
        onLoading?(true)
        if search.isEmpty {
            moviesService.fetchMovies(category: selectedMovieCategory, page: page) { [weak self] result in
                self?.parseResult(page: page, result: result)
            }
        } else {
            moviesService.searchMovies(search: search, page: page) { [weak self] result in
                self?.parseResult(page: page, result: result)
            }
        }
    }
    
    private func parseResult(page: Int, result: Result<MoviesResponse, Error>) {
        DispatchQueue.main.async {
            switch result {
            case .success(let success):
                if page == 1 {
                    self.movies = success.results
                    self.mapGenresForMovies()
                } else {
                    self.movies.append(contentsOf: success.results)
                    self.mapGenresForMovies()
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    func getGenres() {
        genresService.fetchGenres { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                self.genres = success.genres
            case .failure(let failure):
                print(failure.localizedDescription)
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
        onLoading?(false)
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
    
    func goToSelectedMovie(_ movie: Movie) {
        coordinator?.navigateToSelectedMovie(movie)
    }
}
