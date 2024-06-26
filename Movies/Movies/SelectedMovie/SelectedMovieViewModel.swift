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
    var onFailure: ((String?) -> Void)?
    
    private let moviesService: MoviesNetworkServiceProtocol
    private let posterService: PosterNetworkServiceProtocol
    private let trailerService: TrailerNetworkServiceProtocol
    var imageData: Data?
    
    init(id: Int, moviesService: MoviesNetworkServiceProtocol, posterService: PosterNetworkServiceProtocol, trailerService: TrailerNetworkServiceProtocol) {
        self.id = id
        self.moviesService = moviesService
        self.posterService = posterService
        self.trailerService = trailerService
    }
    
    deinit {
        coordinator?.didFinish()
    }
    
    func getMovie() {
        onLoading?(true)
        moviesService.fetchSelectedMovie(id: id) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    self.onLoadSuccess?(success)
                    self.onLoading?(false)
                case .failure(let failure):
                    self.onFailure?(failure.localizedDescription)
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
    
    private func getTrailerKey(id: Int, completion: @escaping (String?) -> Void) {
        trailerService.fetchTrailer(id: id) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    if let trailer = success.results.first {
                        completion(trailer.key)
                    }
                case .failure(let failure):
                    completion(nil)
                    self.onFailure?(failure.localizedDescription)
                }
            }
        }
    }
    
    func wathVideo() {
        getTrailerKey(id: id) { [weak self] key in
            if let key = key {
                self?.coordinator?.presentVideo(videoID: key)
            }
        }
    }
    
    func showImage() {
        if let imageData = imageData {
            coordinator?.presentImage(data: imageData)
        }
    }
}
