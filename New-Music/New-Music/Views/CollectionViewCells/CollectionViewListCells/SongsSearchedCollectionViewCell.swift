//
//  SongsSearchedCollectionViewCell.swift
//  New-Music
//
//  Created by Michael McGrath on 12/31/20.
//

import UIKit

class SongsSearchedCollectionViewCell: UICollectionViewListCell, SelfConfiguringCell {
    static let identifier = "SongsSearchedCell"
    
    var mediaImageView: UIImageView = UIImageView()
    var delegate: SearchCellDelegate?
    let imageSize: CGFloat = 500
    var isInitial = true
    
    func configure(with mediaItem: Media) {
        guard let song = mediaItem.media as? Song else { return }
        self.song = song
//        artistLabel.text = song.artistName
//        songTitleLabel.text = song.songName
//        print("Image View Size: \(mediaImageView.frame.size.width)")
        APIController.shared.fetchImage(mediaItem: song, size: imageSize) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let imageData):
                DispatchQueue.main.async {
                    if let imageData = imageData {
                        self.song?.albumArtwork = imageData
                        if self.isInitial {
                            self.initialSetup()
                            self.isInitial = false
                        } else {
                            self.updateConfiguration(using: self.configurationState)
                        }
                    }
                }
            case .failure(let error):
                print("Error fetching image data: \(error.localizedDescription)")
            }
        }
    }
    
    
    var defaultContentView: UIListContentView?
    var song: Song? {
        didSet {
            guard let song = self.song else { return }
            if let _ = song.albumArtwork {
                DispatchQueue.main.async {
                    self.updateConfiguration(using: self.configurationState)
                    self.layoutIfNeeded()
                }
            } else {
                APIController.shared.fetchImage(mediaItem: song, size: 500) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let imageData):
                        self.song?.albumArtwork = imageData
                        DispatchQueue.main.async {
                            self.updateConfiguration(using: self.configurationState)
                            self.layoutIfNeeded()
                        }
                    case .failure(let error):
                        print("Unable to fetch image data for song: \(song). Error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.tintColor = .white
        button.setSize(width: UIScreen.main.bounds.width / 7, height: UIScreen.main.bounds.width / 7)
        button.setImage(UIImage(systemName: "plus")?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: (UIScreen.main.bounds.width / 7) / 2.5, weight: .semibold, scale: .default)), for: .normal)
		button.addTarget(self, action: #selector(addSong(_:)), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
        var backgroundConfig = UIBackgroundConfiguration.listGroupedCell()
        backgroundConfig.backgroundColor = UIColor.clear
        backgroundConfiguration = backgroundConfig
//		self.separatorLayoutGuide.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: (UIScreen.main.bounds.width / 7) + 28).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("storyboard is trash")
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        self.defaultContentView?.configuration = makeContentConfiguration()
		if state.isHighlighted {
			var backgroundConfig = UIBackgroundConfiguration.listGroupedCell()
			backgroundConfig.backgroundColorTransformer = .preferredTint
			backgroundConfiguration = backgroundConfig
		} else {
			var backgroundConfig = UIBackgroundConfiguration.listGroupedCell()
			backgroundConfig.backgroundColor = .backgroundColor
			backgroundConfiguration = backgroundConfig
		}
    }
    
    func makeContentConfiguration() -> UIListContentConfiguration {
        var config = defaultContentConfiguration()
        config.text = song?.artistName
        config.secondaryText = song?.songName
        config.image = UIImage(data: song?.albumArtwork ?? Data())
        config.imageProperties.maximumSize = CGSize(width: UIScreen.main.bounds.width / 7, height: UIScreen.main.bounds.width / 7)
        config.imageToTextPadding = 8
        config.imageProperties.cornerRadius = 8
        config.textProperties.font = UIFont.preferredFont(forTextStyle: .subheadline)
        config.textProperties.color = .lightText
        config.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .subheadline)
        config.secondaryTextProperties.color = .white
        config.axesPreservingSuperviewLayoutMargins = .both
        config.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20)
        config.secondaryTextProperties.numberOfLines = 2
        config.textToSecondaryTextVerticalPadding = 0
        return config
    }
    
    private func initialSetup() {
        backgroundColor = .clear
        let bgView = UIView()
        bgView.backgroundColor = .clear
        backgroundView = bgView
        let config = makeContentConfiguration()
        let defaultView = UIListContentView(configuration: config)
        self.defaultContentView = defaultView
        let stackView = UIStackView(arrangedSubviews: [defaultContentView!, addButton])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        contentView.addSubview(stackView)
		stackViewConstraints(stackView: stackView, contentView: contentView)
        var backgroundConfig = UIBackgroundConfiguration.listGroupedCell()
        backgroundConfig.backgroundColor = .backgroundColor
        backgroundConfiguration = backgroundConfig
    }
    
    @objc func addSong(_ sender: UIButton) {
        self.song?.isAdded = true
        delegate?.addSongTapped(cell: self)
    }
}
