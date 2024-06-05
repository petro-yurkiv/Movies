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
        image.backgroundColor = .brown
        image.image = UIImage(systemName: "house")
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
                    
                    if let imageData = imageData {
                        self.postImage.image = UIImage(data: imageData)
                    } else {
                        if let image = UIImage(systemName: "x.circle.fill")?.withRenderingMode(.alwaysTemplate) {
                            let resizedImage = image.resizeImage(targetSize: CGSize(width: 40.0, height: 40.0))
                            self.postImage.image = resizedImage
                            self.postImage.contentMode = .center
                            self.postImage.clipsToBounds = true
                        }
                    }
                }
            }
            
            self.nameLabel.text = movie.title
            self.descriptionLabel.text = "\((movie.originCountry.first ?? "") + " " + (Date.yearString(from: movie.releaseDate) ?? "N/A"))"
            
            let genreNames = movie.genres.map { $0.name }.joined(separator: ", ")
            self.genresLabel.text = "Genres: \(genreNames)"
            
            self.ratingLabel.text = "Rating: \(movie.voteAverage)"
            self.overviewLabel.text = movie.overview
        }
    }
}
