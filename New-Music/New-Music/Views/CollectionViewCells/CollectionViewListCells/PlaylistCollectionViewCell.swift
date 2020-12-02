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
    var playlist: Playlist?
    
    @objc private func listenToPlaylist(_ sender: NeuMusicButton) {
        guard let playlist = self.playlist else { return }
        setPlaylistDelegate?.setQueue(with: playlist)
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        var newConfig = PlaylistCellContentConfiguration().updated(for: state)
        
        newConfig.playlistName = playlist?.playlistName
        newConfig.playlist = playlist
        newConfig.setPlaylistDelegate = setPlaylistDelegate
         
        contentConfiguration = newConfig
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.separatorLayoutGuide.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("storyboard is trash")
    }
}
