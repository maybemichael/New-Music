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
    let artistLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .lightText
        return label
    }()
    let songTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .white
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 7
        imageView.clipsToBounds = true
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageView.setSize(width: UIScreen.main.bounds.width / 5.5, height: UIScreen.main.bounds.width / 5.5)
        return imageView
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGrayThree
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
    let addButton: UIButton = {
        let button = UIButton()
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.tintColor = .white
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        return button
    }()
//    let addButton = UIButton(type: .custom)
    let imageSize: CGFloat = 500
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
        artistLabel.text = song.artistName
        songTitleLabel.text = song.songName
        print("Image View Size: \(imageView.frame.size.width)")
        APIController.shared.fetchImage(song: song, size: imageSize) { result in
            switch result {
            case .success(let imageData):
                DispatchQueue.main.async {
                    if let imageData = imageData {
                        self.song?.albumArtwork = imageData
                        self.imageView.image = UIImage(data: imageData)
                    }
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
        addButton.addTarget(self, action: #selector(addSong(_:)), for: .touchUpInside)
        let innerStackView = UIStackView(arrangedSubviews: [artistLabel, songTitleLabel])
        innerStackView.axis = .vertical
        let outerStackView = UIStackView(arrangedSubviews: [imageView, innerStackView, addButton])
        outerStackView.alignment = .center
        outerStackView.distribution = .fill
        outerStackView.spacing = 10
//        contentView.addSubview(outerStackView)
        let mainStackView = UIStackView(arrangedSubviews: [outerStackView, separatorView])
        mainStackView.axis = .vertical
        mainStackView.distribution = .equalCentering
        mainStackView.spacing = 7.5
        contentView.addSubview(mainStackView)
//        outerStackView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, centerX: contentView.centerXAnchor, padding: .init(top: 0, left: 8, bottom: 0, right: -8))
        mainStackView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, centerX: contentView.centerXAnchor, padding: .init(top: 0, left: 8, bottom: 0, right: -8))
    }
    
    @objc func addSong(_ sender: UIButton) {
        self.song?.isAdded = true
        let added = UIImage(systemName: "checkmark.seal", withConfiguration: UIImage.SymbolConfiguration.addSongConfig)
        let add = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration.addSongConfig)
        self.song?.isAdded ?? false ? addButton.setImage(added, for: .normal) : addButton.setImage(add, for: .normal)
        delegate?.addSongTapped(cell: self)
    }
}
