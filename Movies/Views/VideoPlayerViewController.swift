//
//  VideoPlayerViewController.swift
//  Movies
//
//  Created by Petro Yurkiv on 05.06.2024.
//

import UIKit
import AVKit

final class VideoPlayerViewController: UIViewController {
    private var url: URL?
    private var player: AVPlayer?
    private var playerViewController: AVPlayerViewController?

    convenience init(url: URL) {
        self.init()
        self.url = url
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = url else {
            return
        }
        
        player = AVPlayer(url: url)
        playerViewController = AVPlayerViewController()
        playerViewController?.player = player
        
        if let playerViewController = playerViewController {
            addChild(playerViewController)
            view.addSubview(playerViewController.view)
            playerViewController.view.frame = view.bounds
            playerViewController.didMove(toParent: self)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player?.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player?.pause()
    }
}
