//
//  FilterView.swift
//  Movies
//
//  Created by Petro Yurkiv on 03.06.2024.
//

import UIKit
import SnapKit

final class FilterView: UIView {
    var onNowPlayingButtonTapped: (() -> Void)?
    var onPopularButtonTapped: (() -> Void)?
    var onTopRatedButtonTapped: (() -> Void)?
    var onUpcomingButtonTapped: (() -> Void)?
    private var selectedTag: Int = 0
    
    private var verticalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8.0
        stack.distribution = .fillProportionally
        return stack
    }()
    
    func categoryButton(_ text: String, tag: Int) -> UIButton {
        let button = UIButton()
        button.setTitle(text, for: .normal)
        button.layer.cornerRadius = 4.0
        button.tag = tag
        button.setTitleColor(button.tag == selectedTag ? .white : .black, for: .normal)
        button.backgroundColor = button.tag == selectedTag ? .black : .white
        return button
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(verticalStackView)
        verticalStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(16.0)
            make.trailing.equalToSuperview().inset(16.0)
            make.bottom.equalToSuperview()
        }
        
        let nowPlayingButton = categoryButton(MovieCategory.nowPlaying.name, tag: 0)
        let popularButton = categoryButton(MovieCategory.popular.name, tag: 1)
        let topRatedButton = categoryButton(MovieCategory.topRated.name, tag: 2)
        let upcomingButton = categoryButton(MovieCategory.upcoming.name, tag: 3)

        verticalStackView.addArrangedSubview(nowPlayingButton)
        verticalStackView.addArrangedSubview(popularButton)
        verticalStackView.addArrangedSubview(topRatedButton)
        verticalStackView.addArrangedSubview(upcomingButton)
        
        nowPlayingButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        popularButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        topRatedButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        upcomingButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        selectedTag = sender.tag
        updateButtonAppearance()
        switch selectedTag {
        case 0:
            onNowPlayingButtonTapped?()
        case 1:
            onPopularButtonTapped?()
        case 2:
            onTopRatedButtonTapped?()
        case 3:
            onUpcomingButtonTapped?()
        default:
            break
        }
    }
    
    private func updateButtonAppearance() {
        for case let button as UIButton in verticalStackView.arrangedSubviews {
            button.setTitleColor(button.tag == selectedTag ? .white : .black, for: .normal)
            button.backgroundColor = button.tag == selectedTag ? .black : .white
        }
    }
}
