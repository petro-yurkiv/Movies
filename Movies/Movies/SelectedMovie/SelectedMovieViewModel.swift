//
//  SelectedMovieViewModel.swift
//  Movies
//
//  Created by Petro Yurkiv on 04.06.2024.
//

import Foundation

final class SelectedMovieViewModel {
    weak var coordinator: SelectedMovieCoordinator?
    var movie: Movie
    
    var onLoading: ((Bool) -> Void)?
    var onLoadSuccess: (([Movie]) -> Void)?
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    deinit {
        coordinator?.didFinish()
    }
}
