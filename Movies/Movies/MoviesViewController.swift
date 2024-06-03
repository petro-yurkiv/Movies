//
//  ViewController.swift
//  Movies
//
//  Created by Petro Yurkiv on 30.05.2024.
//

import UIKit

class MoviesViewController: UIViewController {
    var viewModel: MoviesViewModel
    private var list: [Movie] = []
    private var isFilterViewHidden = true
    
    init(viewModel: MoviesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Movies"
        setupLayout()
        setupTableView()
        setupFilterButton()
        navigationController?.navigationBar.tintColor = .black
        
        viewModel.getMovies { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    self.list = success
                    self.postsTableView.reloadData()
                case .failure(let failure):
                    print(failure)
                }
            }
        }
    }

    private var mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 8.0
        stack.axis = .vertical
        stack.distribution = .fill
        return stack
    }()
    
    private var postsTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    private var addButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        return button
    }()
    
    private func setupLayout() {
        view.addSubview(mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom)
        }
        
        mainStackView.addArrangedSubview(postsTableView)
    }
    
    private func setupFilterButton() {
        addButton.tintColor = .black
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func setupTableView() {
        postsTableView.separatorStyle = .none
        postsTableView.dataSource = self
        postsTableView.delegate = self
        postsTableView.register(MoviesCell.self, forCellReuseIdentifier: MoviesCell.identifier)
    }
}

extension MoviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MoviesCell.identifier, for: indexPath) as! MoviesCell
        let model = list[indexPath.row]
        if let posterPath = model.posterPath {
            viewModel.getPoster(posterPath: posterPath) { result in
                var imageData: Data?
                DispatchQueue.main.async {
                    switch result {
                    case .success(let success):
                        imageData = success
                    case .failure(_):
                        imageData = nil
                    }
                    
                    cell.setup(model, imageData: imageData)
                }
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
}

extension MoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
