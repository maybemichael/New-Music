//
//  CurrentPlaylistCollectionViewCell.swift
//  New-Music
//
//  Created by Michael McGrath on 11/8/20.
//

import SwiftUI

class CurrentPlaylistCollectionViewCell: UICollectionViewCell {
    static let identifier = "CurrentPlaylistCell"
    var hostedView: UIView? {
        didSet {
            if let oldValue = oldValue {
                if oldValue.isDescendant(of: self) {
                    oldValue.removeFromSuperview()
                }
            }
            if let hostedView = hostedView {
                holderView.addSubview(hostedView)

                hostedView.center = holderView.center
                hostedView.setSize(width: UIScreen.main.bounds.width / 9, height: UIScreen.main.bounds.width / 5.5)
            }
        }
    }
    var song: Song? {
        didSet {
            updateViews()
        }
    }
    
    var indicatorView: PlayingIndicatorViewController? {
        didSet {

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
    
    lazy var mediaImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 7
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageView.setSize(width: contentView.bounds.height - 8, height: contentView.bounds.height - 8)
        return imageView
    }()
    
    lazy var innerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [artistLabel, songTitleLabel])
        stackView.axis = .vertical
        return stackView
    }()
    
    lazy var holderView: UIView = {
        let view = UIView()
        view.setSize(width: UIScreen.main.bounds.width / 9, height: contentView.bounds.height - 8)
        return view
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGrayThree
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("No storyboards...")
    }
    
    private func setUpViews() {
        let outerStackView = UIStackView(arrangedSubviews: [mediaImageView, innerStackView, holderView])
        outerStackView.alignment = .center
        outerStackView.distribution = .fill
        outerStackView.spacing = 8
        let mainStackView = UIStackView(arrangedSubviews: [outerStackView, separatorView])
        mainStackView.axis = .vertical
        mainStackView.distribution = .equalCentering
        mainStackView.spacing = 8
        contentView.addSubview(mainStackView)
        mainStackView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, trailing: contentView.trailingAnchor, centerX: contentView.centerXAnchor, padding: .init(top: 8, left: 0, bottom: -8, right: 0))
    }
    
    private func updateViews() {
        guard let song = self.song else { return }
        artistLabel.text = song.artistName
        songTitleLabel.text = song.songName
        if let imageData = song.albumArtwork {
            mediaImageView.image = UIImage(data: imageData)
        } else {
            APIController.shared.fetchImage(mediaItem: song, size: 500) { result in
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
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        hostedView?.removeFromSuperview()
        hostedView = nil
    }
}
