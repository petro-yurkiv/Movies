//
//  SelectedMovieViewModel.swift
//  Movies
//
//  Created by Petro Yurkiv on 04.06.2024.
//

import Foundation

final class SelectedMovieViewModel {
    weak var coordinator: SelectedMovieCoordinator?
    var id: Int
    
    var onLoading: ((Bool) -> Void)?
    var onLoadSuccess: ((SelectedMovie) -> Void)?
    
    private let moviesService: MoviesNetworkServiceProtocol
    private let posterService: PosterNetworkServiceProtocol
    
    init(id: Int, moviesService: MoviesNetworkServiceProtocol, posterService: PosterNetworkServiceProtocol) {
        self.id = id
        self.moviesService = moviesService
        self.posterService = posterService
    }
    
    deinit {
        coordinator?.didFinish()
    }
    
    func getMovie() {
        moviesService.fetchSelectedMovie(id: id) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    print("success \(success)")
                    self.onLoadSuccess?(success)
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
        }
    }
    
    func getPoster(posterPath: String, completion: @escaping (Result<Data, Error>) -> Void) {
        posterService.getPosterData(posterPath: posterPath) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    completion(.success(success))
                case .failure(let failure):
                    completion(.failure(failure))
                }
            }
        }
    }
}
