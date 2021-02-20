//
//  PlaylistCellContentView.swift
//  New-Music
//
//  Created by Michael McGrath on 11/30/20.
//

import UIKit

class PlaylistCellContentView: UIView, UIContentView {
    
    var playlist: Playlist?
    var playlistDelegate: PlaylistDelegate?
    
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
    
    lazy var playButton: NeuMusicButton = {
        let button = NeuMusicButton()
        button.setTitle("  Play", for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.setTitleColor(.white, for: .normal)
        button.setImage(UIImage(systemName: "play.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 15, weight: .regular, scale: .default).configurationWithoutPointSizeAndWeight()), for: .normal)
        button.setImage(UIImage(systemName: "play.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 15, weight: .regular, scale: .default).configurationWithoutPointSizeAndWeight()), for: .highlighted)
        button.addTarget(self, action: #selector(listenToPlaylist), for: .touchUpInside)
        button.setSize(width: UIScreen.main.bounds.width / 3, height: 40)
        button.tintColor = .white
        button.layer.cornerRadius = 8
        return button
    }()
    
    lazy var shuffleButton: NeuMusicButton = {
        let button = NeuMusicButton()
        button.setTitle(" Shuffle", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.setImage(UIImage(systemName: "shuffle")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 15, weight: .regular, scale: .default).configurationWithoutPointSizeAndWeight()), for: .normal)
        button.setImage(UIImage(systemName: "shuffle")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 15, weight: .regular, scale: .default).configurationWithoutPointSizeAndWeight()), for: .highlighted)
        button.addTarget(self, action: #selector(shufflePlaylist), for: .touchUpInside)
        button.setSize(width: UIScreen.main.bounds.width / 3, height: 40)
        button.tintColor = .white
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
        let stackView = UIStackView(arrangedSubviews: [playlistNameLabel, buttonStackView])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 8
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let top = stackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor)
        top.priority = UILayoutPriority(999)
        let leading = stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        leading.priority = UILayoutPriority(999)
        let trailing = stackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
        trailing.priority = UILayoutPriority(999)
        let bottom = stackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        bottom.priority = UILayoutPriority(999)
        NSLayoutConstraint.activate([
            top,
            leading,
            trailing,
            bottom
        ])
    }
    
    private func apply(configuration: PlaylistCellContentConfiguration) {
        guard currentConfiguration != configuration else { return }
        currentConfiguration = configuration
        playlistNameLabel.text = configuration.playlistName
        playlistStatsLabel.text = "\(configuration.playlist?.songCount ?? 0) songs, \(String(format: "%.0f", configuration.playlist?.totalDuration ?? 0)) mins"
        playlist = configuration.playlist
        playlistDelegate = configuration.setPlaylistDelegate
    }
    
    @objc private func listenToPlaylist(_ sender: NeuMusicButton) {
        guard let playlist = self.playlist else { return }
        playlistDelegate?.setQueue(with: playlist)
    }
    
    @objc private func shufflePlaylist() {
        guard let playlist = self.playlist else { return }
        playlistDelegate?.shuffleSongs(for: playlist)
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
    var setPlaylistDelegate: PlaylistDelegate?
    
    func makeContentView() -> UIView & UIContentView {
        return PlaylistCellContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> PlaylistCellContentConfiguration {
        return self
    }
}
