//
//  SelectedMovieViewController.swift
//  Movies
//
//  Created by Petro Yurkiv on 04.06.2024.
//

import UIKit

final class SelectedMovieViewController: UIViewController {
    var viewModel: SelectedMovieViewModel
    
    init(viewModel: SelectedMovieViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("vc deitited")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        title = "Selected"
        navigationController?.navigationBar.tintColor = .black
    }
}
