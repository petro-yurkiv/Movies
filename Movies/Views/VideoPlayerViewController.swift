//
//  VideoPlayerViewController.swift
//  Movies
//
//  Created by Petro Yurkiv on 05.06.2024.
//

import UIKit
import YouTubeiOSPlayerHelper

final class VideoPlayerViewController: UIViewController {
    private var videoID: String
    
    init(videoID: String) {
        self.videoID = videoID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let playerView = YTPlayerView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        playerView.delegate = self
        playerView.load(withVideoId: videoID)
        view.addSubview(playerView)
    }
}

extension VideoPlayerViewController: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }
}
