//
//  NowPlayingCollectionViewCell.swift
//  New-Music
//
//  Created by Michael McGrath on 12/21/20.
//

import UIKit

class NowPlayingCollectionViewCell: UICollectionViewListCell {
    static let identifier = "NowPlayingCell"
    
    var song: Song?
    var nowPlayingViewModel: NowPlayingViewModel?
    var playID: String?
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        var newConfig = NowPlayingCellContentConfiguration(nowPlayingViewModel: nowPlayingViewModel!).updated(for: state)
        newConfig.songTitle = song?.songName
        newConfig.artist = song?.artistName
        newConfig.albumArtwork = song?.albumArtwork
        newConfig.nowPlayingViewModel = nowPlayingViewModel!
        newConfig.playID = playID
        self.separatorLayoutGuide.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: (UIScreen.main.bounds.width / 7) + 28).isActive = true
        contentConfiguration = newConfig
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        backgroundView = containerView
//        self.separatorLayoutGuide.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("storyboard is trash")
    }
}
