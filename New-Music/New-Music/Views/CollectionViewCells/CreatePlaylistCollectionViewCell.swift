//
//  CreatePlaylistCollectionViewCell.swift
//  New-Music
//
//  Created by Michael McGrath on 11/25/20.
//

import UIKit

class CreatePlaylistCollectionViewCell: UICollectionViewCell {
    static let identifier = "CreatePlaylistCell"
    var song: Song? {
        didSet {
            updateViews()
        }
    }
    
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
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 7
        imageView.setSize(width: contentView.bounds.height - 8, height: contentView.bounds.height - 8)
        return imageView
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGrayThree
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
    
    lazy var innerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [artistLabel, songTitleLabel])
        stackView.axis = .vertical
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("No storyboards...")
    }
    
    private func setUpViews() {
        
        let outerStackView = UIStackView(arrangedSubviews: [imageView, innerStackView])
        outerStackView.alignment = .center
        outerStackView.distribution = .fill
        outerStackView.spacing = 8
        let mainStackView = UIStackView(arrangedSubviews: [outerStackView, separatorView])
        mainStackView.axis = .vertical
        mainStackView.distribution = .equalCentering
        mainStackView.spacing = 8
        contentView.addSubview(mainStackView)
        mainStackView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, centerX: contentView.centerXAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    private func updateViews() {
        guard let song = self.song else { return }
        artistLabel.text = song.artistName
        songTitleLabel.text = song.songName
        if let imageData = song.albumArtwork {
            imageView.image = UIImage(data: imageData)
        }
    }
}
