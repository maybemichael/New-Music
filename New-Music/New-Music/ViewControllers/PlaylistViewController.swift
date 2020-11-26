//
//  PlaylistViewController.swift
//  New-Music
//
//  Created by Michael McGrath on 10/3/20.
//

import SwiftUI
import Combine

class PlaylistViewController: UIViewController {
    private var subscriptions = Set<AnyCancellable>()
    private var nowPlayingViewModel: NowPlayingViewModel!
    var musicController: MusicController!
    weak var coordinator: MainCoordinator?
    let artistLabel = UILabel()
    var backgroundColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .backgroundColor
        navigationController?.view.layer.cornerRadius = 20
        configureContentView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func configureContentView() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Playlists"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createNewPlaylist))
        view.backgroundColor = .backgroundColor
        view.layer.cornerRadius = 20
    }
    
    @objc private func createNewPlaylist() {
        coordinator?.presentCreatePlaylistVC()
    }
}
