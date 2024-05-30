//
//  AppCoordinator.swift
//  Movies
//
//  Created by Petro Yurkiv on 30.05.2024.
//

import UIKit

class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private var window: UIWindow
    private var navigationController = UINavigationController()
    
    init(window: UIWindow) {
        self.window = window
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func start() {
        let coordinator = MoviesCoordinator(parentCoordinator: self, navigationController: navigationController)
        coordinator.start()
        childCoordinators.append(coordinator)
    }
}
