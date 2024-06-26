//
//  MoviesCell.swift
//  Movies
//
//  Created by Petro Yurkiv on 31.05.2024.
//

import UIKit
import SnapKit

final class MoviesCell: UITableViewCell {
    private var wrapView: UIView = {
        let view = UIView()
        return view
    }()
    
    private var mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 8.0
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .leading
        return stack
    }()
    
    private var posterView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8.0
        return imageView
    }()
    
    private var textStackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 8.0
        stack.axis = .vertical
        return stack
    }()
    
    private var lowerStackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 8.0
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        return stack
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24.0, weight: .medium)
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = .min
        label.shadowColor = .black
        label.shadowOffset = CGSize(width: 2.0, height: 2.0)
        return label
    }()
    
    private var genresLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0, weight: .regular)
        label.textColor = .white
        label.textAlignment = .left
        label.shadowColor = .black
        label.shadowOffset = CGSize(width: 2.0, height: 2.0)
        return label
    }()
    
    private var ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0, weight: .regular)
        label.textColor = .white
        label.textAlignment = .left
        label.shadowColor = .black
        label.shadowOffset = CGSize(width: 2.0, height: 2.0)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupWrapView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(_ model: Movie, imageData: Data?) {
        titleLabel.text = "\(model.title + " " + (Date.yearString(from: model.releaseDate) ?? ""))"

        if let genres = model.genres {
            let genreNames = genres.map { $0.name }.joined(separator: ", ")
            genresLabel.text = "Genres: \(genreNames)"
        } else {
            genresLabel.text = "Genres: N/A"
        }
        
        ratingLabel.text = "Rating: \(model.voteAverage)"
        
        if let imageData = imageData {
            posterView.image = UIImage(data: imageData)
        } else {
            if let image = UIImage(systemName: "x.circle.fill")?.withRenderingMode(.alwaysTemplate) {
                let resizedImage = image.resizeImage(targetSize: CGSize(width: 40.0, height: 40.0))
                posterView.image = resizedImage
                posterView.contentMode = .center
                posterView.clipsToBounds = true
            }
        }
    }
    
    private func setupWrapView() {
        wrapView.layer.cornerRadius = 8.0
        wrapView.layer.borderWidth = 0.50
        wrapView.layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
        wrapView.clipsToBounds = false
    }
    
    private func setupLayout() {
        contentView.addSubview(wrapView)
        wrapView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4.0)
            make.leading.equalToSuperview().offset(8.0)
            make.trailing.equalToSuperview().inset(8.0)
            make.bottom.equalToSuperview().inset(4.0)
        }
        
        wrapView.addSubview(posterView)
        posterView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        wrapView.addSubview(mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8.0)
            make.leading.equalToSuperview().offset(8.0)
            make.trailing.equalToSuperview().inset(8.0)
            make.bottom.equalToSuperview().inset(8.0)
        }
        
        textStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(textStackView)
        
        mainStackView.addArrangedSubview(lowerStackView)
        lowerStackView.snp.makeConstraints { make in
            make.height.equalTo(24.0)
            make.trailing.leading.equalToSuperview()
        }
        
        lowerStackView.addArrangedSubview(genresLabel)
        genresLabel.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.size.width / 2)
        }
        
        lowerStackView.addArrangedSubview(ratingLabel)
    }
}
