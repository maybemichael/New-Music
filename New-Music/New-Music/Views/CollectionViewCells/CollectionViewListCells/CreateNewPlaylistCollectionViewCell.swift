//
//  CreatePlaylistCollectionViewCell.swift
//  New-Music
//
//  Created by Michael McGrath on 2/20/21.
//

import UIKit

class CreateNewPlaylistCollectionViewCell: UICollectionViewListCell {
	static let identifier = "New Playlist Section Header"
	weak var playlistDelegate: PlaylistDelegate?
	
	let topSeparatorView: UIView = {
		let view = UIView()
		view.setSize(width: UIScreen.main.bounds.width, height: 0.333333333333)
		view.backgroundColor = .opaqueSeparator
		view.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
		return view
	}()
	
	lazy var tapGesture: UITapGestureRecognizer = {
		let tapGesture = UITapGestureRecognizer()
		tapGesture.addTarget(self, action: #selector(createNewPlaylist))
		return tapGesture
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		addSubview(topSeparatorView)
		topSeparatorView.anchor(top: topAnchor, centerX: centerXAnchor)
		contentConfiguration = makeContentConfiguration()
		contentView.addGestureRecognizer(tapGesture)
		var backgroundConfig = UIBackgroundConfiguration.listGroupedCell()
		backgroundConfig.backgroundColor = .backgroundColor
		backgroundConfiguration = backgroundConfig
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func makeContentConfiguration() -> UIListContentConfiguration {
		var config = defaultContentConfiguration()
		config.imageProperties.maximumSize = CGSize(width: UIScreen.main.bounds.width / 8, height: UIScreen.main.bounds.width / 8)
		config.image = UIImage(systemName: "plus.circle")?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .default))?.withTintColor(.white, renderingMode: .alwaysOriginal)
		config.secondaryText = "Create New Playlist..."
		config.secondaryTextProperties.color = .white
		config.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .headline)
		config.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0)
		config.imageToTextPadding = 8
		
		return config
	}
	
	override func updateConfiguration(using state: UICellConfigurationState) {
		super.updateConfiguration(using: state)
		contentConfiguration = makeContentConfiguration()
	}
	
	@objc private func createNewPlaylist() {
		playlistDelegate?.presentCreatePlaylistVC()
	}
}
