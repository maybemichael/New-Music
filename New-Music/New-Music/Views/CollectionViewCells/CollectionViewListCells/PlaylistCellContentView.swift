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
        label.textColor = .lightText
        label.font = UIFont.preferredFont(forTextStyle: .headline).withSize(12)
        label.textAlignment = .left
        return label
    }()
    
    let playButton: NeuMusicButton = {
        let button = NeuMusicButton()
        button.setTitle("  Play", for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline).withSize(15)
        button.setTitleColor(.white, for: .normal)
        button.setImage(UIImage(systemName: "play.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 15, weight: .regular, scale: .default)), for: .normal)
        button.tintColor = .white
        button.setSize(width: 100, height: 40)
        button.layer.cornerRadius = 8
        return button
    }()
    
    let shuffleButton: NeuMusicButton = {
        let button = NeuMusicButton()
        button.setTitle(" Shuffle", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline).withSize(15)
        button.setImage(UIImage(systemName: "shuffle")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 15, weight: .regular, scale: .default)), for: .normal)
        button.tintColor = .white
        button.setSize(width: 100, height: 40)
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
        let buttonStackView = UIStackView(arrangedSubviews: [playButton, shuffleButton])
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 20
        let stackView = UIStackView(arrangedSubviews: [playlistNameLabel, buttonStackView, playlistStatsLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 8
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .topMargin, multiplier: 1, constant: 0)
        topConstraint.priority = UILayoutPriority(999)
        let leadingConstraint = NSLayoutConstraint(item: stackView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leadingMargin, multiplier: 1, constant: 20)
        leadingConstraint.priority = UILayoutPriority(999)
        let trailingConstraint = NSLayoutConstraint(item: stackView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailingMargin, multiplier: 1, constant: 0)
        trailingConstraint.priority = UILayoutPriority(999)
        let bottomConstraint = NSLayoutConstraint(item: stackView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottomMargin, multiplier: 1, constant: 0)
        bottomConstraint.priority = UILayoutPriority(999)
        NSLayoutConstraint.activate([
            topConstraint,
            leadingConstraint,
            trailingConstraint,
            bottomConstraint
        ])
        playButton.addTarget(self, action: #selector(listenToPlaylist), for: .touchUpInside)
        var backgroundConfig = UIBackgroundConfiguration.listGroupedCell()
        backgroundConfig.backgroundColor = .clear
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
