//
//  SelectedMovieViewController.swift
//  Movies
//
//  Created by Petro Yurkiv on 04.06.2024.
//

import UIKit
import SnapKit

final class SelectedMovieViewController: UIViewController {
    var viewModel: SelectedMovieViewModel
    
    private var scrollView: UIScrollView = {
       let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        scroll.isScrollEnabled = true
        return scroll
    }()
    
    private var wrapView: UIView = {
        let view = UIView()
        return view
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        configureLabel(label, fontSize: 24.0)
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        configureLabel(label, fontSize: 24.0)
        return label
    }()
    
    private var genresLabel: UILabel = {
        let label = UILabel()
        configureLabel(label, fontSize: 24.0)
        return label
    }()
    
    private var postImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    var stackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 4.0
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private var trailerButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "video.circle.fill"), for: .normal)
        button.tintColor = .black
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return button
    }()
    
    private var ratingLabel: UILabel = {
        let label = UILabel()
        configureLabel(label, fontSize: 16.0)
        return label
    }()
    
    private var overviewLabel: UILabel = {
        let label = UILabel()
        configureLabel(label, fontSize: 16.0)
        return label
    }()
    
    init(viewModel: SelectedMovieViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNavigationBar()
        setupLayout()
        setupBindings()
        setupRefresh()
        setupTrailerButton()
        setupPostImage()
        viewModel.getMovie()
    }
    
    private func configureNavigationBar() {
        title = "Selected"
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(wrapView)
        wrapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view)
            make.height.greaterThanOrEqualToSuperview()
        }
        
        wrapView.addSubview(postImage)
        postImage.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(view.snp.width).multipliedBy(0.5)
        }
        
        addLabelToWrapView(nameLabel, below: postImage)
        addLabelToWrapView(descriptionLabel, below: nameLabel)
        addLabelToWrapView(genresLabel, below: descriptionLabel)
        
        wrapView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(genresLabel.snp.bottom).offset(16.0)
            make.leading.equalToSuperview().offset(16.0)
            make.trailing.equalToSuperview().inset(16.0)
            make.height.equalTo(32.0)
        }
        
        trailerButton.snp.makeConstraints { make in
            make.height.width.equalTo(32.0)
        }
        
        stackView.addArrangedSubview(trailerButton)
        stackView.addArrangedSubview(ratingLabel)
        
        addLabelToWrapView(overviewLabel, below: stackView)
    }
    
    private func addLabelToWrapView(_ label: UILabel, below view: UIView) {
        wrapView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(view.snp.bottom).offset(16.0)
            make.leading.trailing.equalToSuperview().inset(16.0)
        }
    }
    
    private static func configureLabel(_ label: UILabel, fontSize: CGFloat) {
        label.font = .systemFont(ofSize: fontSize, weight: .regular)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = .min
    }
    
    private func setupBindings() {
        viewModel.onLoading = { [weak self] isLoading in
            guard let self else { return }
            if isLoading {
                scrollView.refreshControl?.beginRefreshing()
            } else {
                scrollView.refreshControl?.endRefreshing()
            }
        }
        
        viewModel.onLoadSuccess = { [weak self] movie in
            guard let self else { return }
            if let posterPath = movie.posterPath {
                self.viewModel.getPoster(posterPath: posterPath) { result in
                    var imageData: Data?
                    switch result {
                    case .success(let success):
                        imageData = success
                    case .failure(_):
                        imageData = nil
                    }
                    
                    self.updateUI(data: imageData, movie: movie)
                }
            }
        }
    }
    
    private func setupRefresh() {
        let controll = UIRefreshControl()
        controll.addTarget(self, action: #selector(onMovieLoading), for: .valueChanged)
        scrollView.refreshControl = controll
    }
    
    private func setupTrailerButton() {
        trailerButton.addTarget(self, action: #selector(onTrailerButtonTap), for: .touchUpInside)
    }
    
    private func setupPostImage() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        postImage.addGestureRecognizer(tapGesture)
        postImage.isUserInteractionEnabled = true
    }
    
    private func setPostImage(data: Data?) {
        if let data = data {
            viewModel.imageData = data
            postImage.image = UIImage(data: data)
        } else {
            if let image = UIImage(systemName: "x.circle.fill")?.withRenderingMode(.alwaysTemplate) {
                let resizedImage = image.resizeImage(targetSize: CGSize(width: 40.0, height: 40.0))
                postImage.image = resizedImage
                postImage.contentMode = .center
                postImage.clipsToBounds = true
            }
        }
    }
    
    private func updateUI(data: Data?, movie: SelectedMovie) {
        setPostImage(data: data)
        nameLabel.text = movie.title
        descriptionLabel.text = "\((movie.originCountry.first ?? "") + " " + (Date.yearString(from: movie.releaseDate) ?? "N/A"))"
        
        let genreNames = movie.genres.map { $0.name }.joined(separator: ", ")
        genresLabel.text = "Genres: \(genreNames)"
        
        ratingLabel.text = "Rating: \(movie.voteAverage)"
        overviewLabel.text = movie.overview
    }
    
    @objc private func onMovieLoading() {
        viewModel.getMovie()
    }
    
    @objc private func onTrailerButtonTap() {
        viewModel.wathVideo()
    }
    
    @objc private func imageTapped() {
        viewModel.showImage()
    }
}
