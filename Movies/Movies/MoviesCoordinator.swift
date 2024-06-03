//
//  MoviesCoordinator.swift
//  Movies
//
//  Created by Petro Yurkiv on 30.05.2024.
//

import UIKit

class MoviesCoordinator: ChildCoordinator {
    var parentCoordinator: Coordinator
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    required init(parentCoordinator: Coordinator, navigationController: UINavigationController) {
        self.parentCoordinator = parentCoordinator
        self.navigationController = navigationController
    }
    
    func start() {
        let networkService = MoviesNetworkService()
        let posterService = PosterNetworkService()
        let viewModel = MoviesViewModel(networkService: networkService, posterService: posterService)
        let vc = MoviesViewController(viewModel: viewModel)
        navigationController.setViewControllers([vc], animated: true)
    }
}
