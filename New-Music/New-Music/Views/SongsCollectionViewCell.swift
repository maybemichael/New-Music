//
//  SongsCollectionViewCell.swift
//  New-Music
//
//  Created by Michael McGrath on 10/3/20.
//

import UIKit

protocol SongsCellDelegate: AnyObject {
    func addSongTapped(cell: SongsCollectionViewCell)
}

class SongsCollectionViewCell: UICollectionViewCell, SelfConfiguringCell {
    static let identifier = "SongCell"
    
    let artist = UILabel()
    let songTitle = UILabel()
    let imageView = UIImageView()
    let addButton = UIButton(type: .custom)
    weak var delegate: SongsCellDelegate?
    var song: Song? {
        didSet {
            let added = UIImage(systemName: "checkmark.seal", withConfiguration: UIImage.SymbolConfiguration.addSongConfig)
            let add = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration.addSongConfig)
            self.song?.isAdded ?? false ? addButton.setImage(added, for: .normal) : addButton.setImage(add, for: .normal)
        }
    }
    
    func configure(with song: Song) {
        self.song = song
        artist.text = song.artistName
        songTitle.text = song.songName
        print("URL: \(song.imageURL)")
        APIController.shared.fetchImage(url: song.imageURL) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            case .failure(let error):
                print("Error fetching image data: \(error.localizedDescription)")
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("No storyboards...")
    }
    
    private func setUpViews() {
        artist.font = UIFont.preferredFont(forTextStyle: .headline)
        artist.textColor = .white
        songTitle.font = UIFont.preferredFont(forTextStyle: .subheadline)
        songTitle.textColor = .lightText
        songTitle.lineBreakMode = .byWordWrapping
        songTitle.numberOfLines = 0
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.setSize(width: UIScreen.main.bounds.width / 5, height: UIScreen.main.bounds.width / 5)
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        addButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        addButton.tintColor = .white
        let innerStackView = UIStackView(arrangedSubviews: [artist, songTitle])
        innerStackView.axis = .vertical
        let outerStackView = UIStackView(arrangedSubviews: [imageView, innerStackView, addButton])
        outerStackView.alignment = .center
        outerStackView.distribution = .fill
        outerStackView.spacing = 10
        contentView.addSubview(outerStackView)
        outerStackView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, centerX: contentView.centerXAnchor)
        addButton.addTarget(self, action: #selector(addSong(_:)), for: .touchUpInside)
        let added = UIImage(systemName: "checkmark.seal", withConfiguration: UIImage.SymbolConfiguration.addSongConfig)
        let add = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration.addSongConfig)
        self.song?.isAdded ?? false ? addButton.setImage(added, for: .normal) : addButton.setImage(add, for: .normal)
    }
    
    @objc func addSong(_ sender: UIButton) {
        MusicController.shared.addSongToPlaylist(song: self.song!)
        self.song?.isAdded = true
        delegate?.addSongTapped(cell: self)
//        addButton.setImage(UIImage(), for: .normal)
    }
}
