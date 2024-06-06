//
//  SelectedMovieCoordinator.swift
//  Movies
//
//  Created by Petro Yurkiv on 04.06.2024.
//

import UIKit

final class SelectedMovieCoordinator: ChildCoordinator {
    var parentCoordinator: Coordinator
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    required init(parentCoordinator: Coordinator, navigationController: UINavigationController) {
        self.parentCoordinator = parentCoordinator
        self.navigationController = navigationController
    }
    
    func start(_ id: Int) {
        let moviesService = MoviesNetworkService()
        let posterService = PosterNetworkService()
        let trailerService = TrailerNetworkService()
        let viewModel = SelectedMovieViewModel(id: id, moviesService: moviesService, posterService: posterService, trailerService: trailerService)
        viewModel.coordinator = self
        let vc = SelectedMovieViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func presentVideo(videoID: String) {
        let vc = VideoPlayerViewController(videoID: videoID)
        navigationController.present(vc, animated: true)
    }
    
    func presentImage(data: Data) {
        let vc = ImageViewController(imageData: data)
        navigationController.present(vc, animated: true)
    }
}
