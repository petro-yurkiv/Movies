//
//  ViewController.swift
//  Movies
//
//  Created by Petro Yurkiv on 30.05.2024.
//

import UIKit

final class MoviesViewController: UIViewController {
    var viewModel: MoviesViewModel
    private var list: [Movie] = []
    private var isFilterViewHidden = true
    private var searchText: String = ""
    private var currentPage: Int = 1
    
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
        setupLayout()
        setupTableView()
        configureNavigationBar()
        setupBindings()
        viewModel.getGenres()
        viewModel.fetch(search: "", page: 1)
    }
    
    private func configureNavigationBar() {
        title = "Movies"
        navigationController?.navigationBar.tintColor = .black
        
        let search = UISearchController(searchResultsController: nil)
        search.delegate = self
        search.searchBar.delegate = self
        self.navigationItem.searchController = search

        let rightButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .done, target: self, action: #selector(rightButtonTapped))
        rightButton.tintColor = .black
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    @objc func rightButtonTapped() {
        filterView.isHidden.toggle()
    }

    private var mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 8.0
        stack.axis = .vertical
        stack.distribution = .fill
        return stack
    }()
    
    private var filterView: FilterView = {
        let view = FilterView()
        view.isHidden = true
        return view
    }()
    
    private var moviesTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    private var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.isHidden = true
        spinner.color = .gray
        return spinner
    }()
    
    private func setupLayout() {
        view.addSubview(spinner)
        view.bringSubviewToFront(spinner)
        spinner.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        view.addSubview(mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom)
        }
        
        mainStackView.addArrangedSubview(filterView)
        mainStackView.addArrangedSubview(moviesTableView)
    }
    
    private func setupTableView() {
        moviesTableView.separatorStyle = .none
        moviesTableView.dataSource = self
        moviesTableView.delegate = self
        moviesTableView.register(MoviesCell.self, forCellReuseIdentifier: MoviesCell.identifier)
        
        let controll = UIRefreshControl()
        controll.addTarget(self, action: #selector(onMoviesLoading), for: .valueChanged)
        moviesTableView.refreshControl = controll
    }
    
    @objc private func onMoviesLoading() {
        viewModel.fetch(search: searchText, page: 1)
    }
    
    private func setupBindings() {
        viewModel.onLoading = { [weak self] isLoading in
            guard let self else { return }
            if isLoading {
                moviesTableView.refreshControl?.beginRefreshing()
                self.view.bringSubviewToFront(self.spinner)
                self.mainStackView.isHidden = true
                self.spinner.isHidden = false
                self.spinner.startAnimating()
            } else {
                moviesTableView.refreshControl?.endRefreshing()
                self.spinner.stopAnimating()
                self.mainStackView.isHidden = false
            }
        }
        
        viewModel.onLoadSuccess = { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                self.list = result
                self.moviesTableView.reloadData()
            }
        }
        
        viewModel.onFailure = { [weak self] failure in
            guard let self else { return }
            guard let failure else { return }
            let alert = UIAlertController(title: failure,
                                          message: nil,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .cancel))
            present(alert, animated: true)
        }
        
        filterView.onNowPlayingButtonTapped = { [weak self] in
            guard let self else { return }
            self.viewModel.selectedMovieCategory = .nowPlaying
            self.filterView.isHidden.toggle()
            self.viewModel.fetch(search: "", page: 1)
        }
        
        filterView.onPopularButtonTapped = { [weak self] in
            guard let self else { return }
            self.viewModel.selectedMovieCategory = .popular
            self.filterView.isHidden.toggle()
            self.viewModel.fetch(search: "", page: 1)
        }
        
        filterView.onTopRatedButtonTapped = { [weak self] in
            guard let self else { return }
            self.viewModel.selectedMovieCategory = .topRated
            self.filterView.isHidden.toggle()
            self.viewModel.fetch(search: "", page: 1)
        }
        
        filterView.onUpcomingButtonTapped = { [weak self] in
            guard let self else { return }
            self.viewModel.selectedMovieCategory = .upcoming
            self.filterView.isHidden.toggle()
            self.viewModel.fetch(search: "", page: 1)
        }
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastItem = self.list.count - 1
        if indexPath.row == lastItem {
            currentPage += 1
            viewModel.fetch(search: searchText, page: currentPage)
        }
    }
}

extension MoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = list[indexPath.row]
        viewModel.goToSelectedMovie(selectedMovie)
    }
}

extension MoviesViewController: UISearchBarDelegate, UISearchControllerDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        viewModel.fetch(search: searchText, page: 1)
    }
}
