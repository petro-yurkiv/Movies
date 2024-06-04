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
    
    deinit {
        print("coordinator deitited")
    }
    
    func start(_ movie: Movie) {
        let viewModel = SelectedMovieViewModel(movie: movie)
        viewModel.coordinator = self
        let vc = SelectedMovieViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
    }
}
