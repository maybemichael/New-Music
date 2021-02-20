//
//  ExistingPlaylistCollectionViewCell.swift
//  New-Music
//
//  Created by Michael McGrath on 1/24/21.
//

import UIKit

class ExistingPlaylistCollectionViewCell: UICollectionViewListCell {
	var defaultContentView: UIListContentView?
	var songSetting: Setting? {
		didSet {
			updateConfiguration(using: self.configurationState)
		}
	}
	
	let iconImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.clipsToBounds = true
		imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		imageView.tintColor = .white
		imageView.setSize(width: 35, height: 35)
		return imageView
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		let config = defaultContentConfiguration()
		let defaultView = UIListContentView(configuration: config)
		defaultView.translatesAutoresizingMaskIntoConstraints = false
		defaultView.heightAnchor.constraint(equalToConstant: 50).isActive = true
		self.defaultContentView = defaultView
		let stackView = UIStackView(arrangedSubviews: [defaultView, iconImageView])
		stackView.alignment = .center
		stackView.axis = .horizontal
		stackView.distribution = .fill
		contentView.addSubview(stackView)
        iconImageView.setSize(width: 35, height: 35)
		stackView.translatesAutoresizingMaskIntoConstraints = false
		let top = stackView.topAnchor.constraint(equalTo: contentView.topAnchor)
		top.priority = UILayoutPriority(999)
		let leading = stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
		leading.priority = UILayoutPriority(999)
		let trailing = stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
		trailing.priority = UILayoutPriority(999)
		let bottom = stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		bottom.priority = UILayoutPriority(999)
		let height = stackView.heightAnchor.constraint(equalToConstant: 70)
		height.priority = UILayoutPriority(999)
		NSLayoutConstraint.activate([
			top,
			leading,
			trailing,
//			bottom
			height
		])
//		stackViewConstraints(stackView: stackView, contentView: contentView)
		var bgConfig = UIBackgroundConfiguration.listGroupedCell().updated(for: self.configurationState)
		bgConfig.backgroundColor = .backgroundColor
		backgroundConfiguration = bgConfig
	}
	
	required init?(coder: NSCoder) {
		fatalError("storyboard is trash")
	}
	
	private func makeContentViewConfiguration() -> UIListContentConfiguration {
		var config = defaultContentConfiguration()
		config.textProperties.font = UIFont.preferredFont(forTextStyle: .headline)
		config.textProperties.color = .white
		config.textProperties.adjustsFontSizeToFitWidth = true
		config.textProperties.numberOfLines = 2
		config.textProperties.minimumScaleFactor = 0.8
		config.imageProperties.maximumSize = CGSize(width: 35, height: 35)
		config.imageProperties.tintColor = .systemGreen
		config.image = UIImage(systemName: "plus.square.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 35, weight: .medium, scale: .default))
		config.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20)
		iconImageView.image = UIImage(systemName: "music.note.list", withConfiguration: UIImage.SymbolConfiguration(pointSize: 35, weight: .medium, scale: .default))
		let playlistMedia = songSetting?.setting as! PlaylistMedia
		if case PlaylistMedia.playlist(let playlist) = playlistMedia {
			config.text = playlist.playlistName
		}
		
		return config
	}
	
	override func updateConfiguration(using state: UICellConfigurationState) {
		defaultContentView?.configuration = makeContentViewConfiguration()
	}
}
