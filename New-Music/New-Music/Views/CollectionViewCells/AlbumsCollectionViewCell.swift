//
//  AlbumsCollectionViewCell.swift
//  New-Music
//
//  Created by Michael McGrath on 10/3/20.
//

import SwiftUI

class AlbumsCollectionViewCell: UICollectionViewCell, SelfConfiguringCell {
    
    static var identifier: String = "AlbumCell"
    var delegate: SearchCellDelegate?
    var album: Album?
    
    let artistLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .lightText
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()
    let albumTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .white
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    let mediaImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 7
        imageView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("No storyboards...")
    }
    
    func configure(with mediaItem: Media) {
        guard let album = mediaItem.media as? Album else { return }
        self.album = album
        artistLabel.text = album.artistName
        albumTitleLabel.text = album.albumName
        APIController.shared.fetchImage(mediaItem: album, size: 500) { result in
            switch result {
            case .success(let imageData):
                DispatchQueue.main.async {
                    if let imageData = imageData {
                        self.album?.albumArtwork = imageData
                        self.mediaImageView.image = UIImage(data: imageData)
                    }
                }
            case .failure(let error):
                print("Error fetching image data: \(error.localizedDescription)")
            }
        }
    }
    
    private func setUpViews() {
        addSubview(mediaImageView)
        addSubview(artistLabel)
        addSubview(albumTitleLabel)
        mediaImageView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        mediaImageView.heightAnchor.constraint(equalTo: mediaImageView.widthAnchor).isActive = true
        artistLabel.anchor(top: mediaImageView.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        albumTitleLabel.anchor(top: artistLabel.bottomAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
    }
}
