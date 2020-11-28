//
//  PlaylistCollectionViewCell.swift
//  New-Music
//
//  Created by Michael McGrath on 11/27/20.
//

import UIKit

class PlaylistCollectionViewCell: UICollectionViewListCell {
    static let identifier = "PlaylistCell"
    
    var setPlaylistDelegate: SetPlaylistDelegate?
    var playlist: Playlist? {
        didSet {
            updateViews()
        }
    }
    
    let playlistNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .headline).withSize(25)
        label.textAlignment = .center
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()
    
    let playButton: NeuMusicButton = {
        let button = NeuMusicButton()
        button.setTitle(" Play", for: .normal)
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.tintColor = .white
        button.setSize(width: 125, height: 40)
        button.layer.cornerRadius = 8
//        button.addTarget(self, action: #selector(listenToPlaylist), for: .touchUpInside)
        return button
    }()
    
    private func setupViews() {
        setSize(width: self.bounds.width, height: 80)
        contentView.addSubview(playButton)
        playButton.anchor(leading: contentView.leadingAnchor, centerY: contentView.centerYAnchor, padding: .init(top: 0, left: 20, bottom: 0, right: 0))
        separatorLayoutGuide.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        let headerDisclosureOption = UICellAccessory.OutlineDisclosureOptions(style: .header, isHidden: false, tintColor: .white)
        let outlineDisclosure: UICellAccessory = .outlineDisclosure(displayed: .always, options: headerDisclosureOption, actionHandler: .none)
        self.accessories = [outlineDisclosure]
        playButton.addTarget(self, action: #selector(listenToPlaylist), for: .touchUpInside)
    }
    
    private func updateViews() {
        guard let playlist = playlist else { return }
        playlistNameLabel.text = playlist.playlistName
    }
    
    @objc private func listenToPlaylist(_ sender: NeuMusicButton) {
        guard let playlist = self.playlist else { return }
        setPlaylistDelegate?.setQueue(with: playlist)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("storyboard is trash")
    }
}
