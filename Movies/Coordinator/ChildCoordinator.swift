//
//  ChildCoordinator.swift
//  Movies
//
//  Created by Petro Yurkiv on 30.05.2024.
//

import UIKit

protocol ChildCoordinator: Coordinator {
    init(parentCoordinator: Coordinator, navigationController: UINavigationController)
    var navigationController: UINavigationController { get set }
    func didFinish()
    var parentCoordinator: Coordinator { get set }
}

extension ChildCoordinator {
    func didFinish() {
        parentCoordinator.childDidFinish(self)
    }
}
