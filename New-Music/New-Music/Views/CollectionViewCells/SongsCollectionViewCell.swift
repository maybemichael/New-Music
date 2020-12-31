//
//  SongsCollectionViewCell.swift
//  New-Music
//
//  Created by Michael McGrath on 10/3/20.
//

import SwiftUI

//protocol SearchCellDelegate: AnyObject {
//    func addSongTapped(cell: SongsCollectionViewCell)
//}

class SongsCollectionViewCell: UICollectionViewCell, SelfConfiguringCell {
    static let identifier = "SongCell"
    let imageSize: CGFloat = 500
    weak var delegate: SearchCellDelegate?

    let artistLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .lightText
        return label
    }()
    
    let songTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .white
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    let mediaImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 7
        imageView.clipsToBounds = true
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return imageView
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .opaqueSeparator
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        return view
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.tintColor = .white
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        return button
    }()
    
    var song: Song? {
        didSet {
            let added = UIImage(systemName: "checkmark.seal", withConfiguration: UIImage.SymbolConfiguration.addSongConfig)
            let add = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration.addSongConfig)
            self.song?.isAdded ?? false ? addButton.setImage(added, for: .normal) : addButton.setImage(add, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        mediaImageView.setSize(width: UIScreen.main.bounds.width / 6, height: UIScreen.main.bounds.width / 6)
    }
    
    required init?(coder: NSCoder) {
        fatalError("No storyboards...")
    }
    
    func configure(with mediaItem: Media) {
        guard let song = mediaItem.media as? Song else { return }
        self.song = song
        artistLabel.text = song.artistName
        songTitleLabel.text = song.songName
        print("Image View Size: \(mediaImageView.frame.size.width)")
        APIController.shared.fetchImage(mediaItem: song, size: imageSize) { result in
            switch result {
            case .success(let imageData):
                DispatchQueue.main.async {
                    if let imageData = imageData {
                        self.song?.albumArtwork = imageData
                        self.mediaImageView.image = UIImage(data: imageData)
                    }
                }
            case .failure(let error):
                print("Error fetching image data: \(error.localizedDescription)")
            }
        }
    }
    
    private func setUpViews() {
        addButton.addTarget(self, action: #selector(addSong(_:)), for: .touchUpInside)
        let innerStackView = UIStackView(arrangedSubviews: [artistLabel, songTitleLabel])
        innerStackView.axis = .vertical
        let outerStackView = UIStackView(arrangedSubviews: [mediaImageView, innerStackView, addButton])
        outerStackView.alignment = .center
        outerStackView.distribution = .fill
        outerStackView.spacing = 8
        let mainStackView = UIStackView(arrangedSubviews: [outerStackView, separatorView])
        mainStackView.axis = .vertical
        mainStackView.distribution = .equalCentering
        mainStackView.spacing = 6
        contentView.addSubview(mainStackView)
        mainStackView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    @objc func addSong(_ sender: UIButton) {
        self.song?.isAdded = true
        let added = UIImage(systemName: "checkmark.seal", withConfiguration: UIImage.SymbolConfiguration.addSongConfig)
        let add = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration.addSongConfig)
        self.song?.isAdded ?? false ? addButton.setImage(added, for: .normal) : addButton.setImage(add, for: .normal)
        delegate?.addSongTapped(cell: self)
    }
}
