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
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.setSize(width: UIScreen.main.bounds.width / 4, height: UIScreen.main.bounds.width / 4)
        return view
    }()
    
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
        return button
    }()
    
    private func setupViews() {
//        let heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 0, constant: UIScreen.main.bounds.width / 4)
//        heightConstraint.isActive = true
//        heightConstraint.priority = UILayoutPriority(rawValue: 999)
//        setSize(width: self.bounds.width, height: 80)
        contentView.addSubview(containerView)
//        contentView.addSubview(playButton)
//        contentView.addSubview(playlistNameLabel)
        containerView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, bottom: contentView.bottomAnchor)
        containerView.addSubview(playButton)
        containerView.addSubview(playlistNameLabel)
        
        playlistNameLabel.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, padding: .init(top: 8, left: 20, bottom: 0, right: 0))
        playButton.anchor(top: playlistNameLabel.bottomAnchor, leading: containerView.leadingAnchor, padding: .init(top: 8, left: 20, bottom: 0, right: 0))
//        playButton.anchor(leading: contentView.leadingAnchor, centerY: contentView.centerYAnchor, padding: .init(top: 0, left: 20, bottom: 0, right: 0))
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
