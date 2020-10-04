//
//  SongsCollectionViewCell.swift
//  New-Music
//
//  Created by Michael McGrath on 10/3/20.
//

import UIKit

class SongsCollectionViewCell: UICollectionViewCell, SelfConfiguringCell {
    static let identifier = "SongCell"
    
    let artist = UILabel()
    let songTitle = UILabel()
    let imageView = UIImageView()
    let addButton = UIButton(type: .custom)
    
    func configure(with song: Song) {
        artist.text = song.artistName
        songTitle.text = song.songName
        MusicController.shared.fetchImage(url: song.imageURL) { result in
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
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        addButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        let innerStackView = UIStackView(arrangedSubviews: [artist, songTitle])
        innerStackView.axis = .vertical
        let outerStackView = UIStackView(arrangedSubviews: [imageView, innerStackView, addButton])
        outerStackView.alignment = .center
        outerStackView.distribution = .fill
        outerStackView.spacing = 10
        contentView.addSubview(outerStackView)
        outerStackView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, centerX: contentView.centerXAnchor)
        
    }
}
