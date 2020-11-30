//
//  PlaylistCellContentView.swift
//  New-Music
//
//  Created by Michael McGrath on 11/30/20.
//

import UIKit

class PlaylistCellContentView: UIView, UIContentView {
    
    var playlist: Playlist?
    var setPlaylistDelegate: SetPlaylistDelegate?
    
    let playlistNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .headline).withSize(25)
        label.textAlignment = .left
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()
    
    let playlistStatsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .headline).withSize(12)
        label.textAlignment = .left
        return label
    }()
    
    let playButton: NeuMusicButton = {
        let button = NeuMusicButton()
        button.setTitle(" Play", for: .normal)
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.tintColor = .white
        button.setSize(width: 125, height: 40)
        button.layer.cornerRadius = 8
        return button
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.setSize(width: UIScreen.main.bounds.width, height: 108)
        return view
    }()
    
    private var currentConfiguration: PlaylistCellContentConfiguration!
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        }
        
        set {
            guard let newConfig = newValue as? PlaylistCellContentConfiguration else { return }
            apply(configuration: newConfig)
        }
    }
    
    init(configuration: PlaylistCellContentConfiguration) {
        super.init(frame: .zero)
        setupViews()
        apply(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Storyboard is not the best thing in the world")
    }
    
    private func setupViews() {
        addSubview(containerView)
        containerView.addSubview(playlistNameLabel)
        containerView.addSubview(playButton)
        containerView.addSubview(playlistStatsLabel)
        containerView.anchor(top: layoutMarginsGuide.topAnchor, leading: layoutMarginsGuide.leadingAnchor, trailing: layoutMarginsGuide.trailingAnchor, bottom: layoutMarginsGuide.bottomAnchor)
        playlistNameLabel.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, trailing: containerView.trailingAnchor, padding: .init(top: 0, left: 20, bottom: 0, right: 0))
        playlistStatsLabel.anchor(top: playlistNameLabel.bottomAnchor, leading: containerView.leadingAnchor, padding: .init(top: 8, left: 20, bottom: 0, right: 0))
        playButton.anchor(top: playlistStatsLabel.bottomAnchor, leading: containerView.leadingAnchor, padding: .init(top: 8, left: 20, bottom: 0, right: 0))
//        playlistStatsLabel.anchor(leading: playButton.trailingAnchor, trailing: containerView.trailingAnchor, centerY: playButton.centerYAnchor, padding: .init(top: 0, left: 8, bottom: 0, right: 0))
        playButton.addTarget(self, action: #selector(listenToPlaylist), for: .touchUpInside)
        
    }
    
    private func apply(configuration: PlaylistCellContentConfiguration) {
        guard currentConfiguration != configuration else { return }
        currentConfiguration = configuration
        playlistNameLabel.text = configuration.playlistName
        playlistStatsLabel.text = "\(configuration.playlist?.songCount ?? 0) songs, \(String(format: "%.0f", configuration.playlist?.totalDuration ?? 0)) mins"
        playlist = configuration.playlist
        setPlaylistDelegate = configuration.setPlaylistDelegate
    }
    
    @objc private func listenToPlaylist(_ sender: NeuMusicButton) {
        guard let playlist = self.playlist else { return }
        setPlaylistDelegate?.setQueue(with: playlist)
    }
}

struct PlaylistCellContentConfiguration: UIContentConfiguration, Hashable {
    static func == (lhs: PlaylistCellContentConfiguration, rhs: PlaylistCellContentConfiguration) -> Bool {
        lhs.playlist == rhs.playlist
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(playlist)
    }
    
    var playlistName: String?
    var playlist: Playlist?
    var setPlaylistDelegate: SetPlaylistDelegate?
    
    func makeContentView() -> UIView & UIContentView {
        return PlaylistCellContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> PlaylistCellContentConfiguration {
        return self
    }
}
