//
//  ViewController.swift
//  Movies
//
//  Created by Petro Yurkiv on 30.05.2024.
//

import UIKit

class MoviesViewController: UIViewController {
    var viewModel: MoviesViewModel
    
    init(viewModel: MoviesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movies"
        view.backgroundColor = .red
        viewModel.getMovies()
    }
}
