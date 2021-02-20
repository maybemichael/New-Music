//
//  SettingCollectionViewCell.swift
//  New-Music
//
//  Created by Michael McGrath on 1/23/21.
//

import UIKit

class SearchedSongSettingCollectionViewCell: UICollectionViewListCell {
	static let identifier = "SettingCell"
	
	var setting: Setting? {
		didSet {
			setting(for: settingType ?? .playlistSetting)
		}
	}
	var settingType: SettingType? {
		didSet {
//            setting(for: settingType ?? .playlistSetting)
		}
	}
	
	weak var settingsDelegate: SettingsDelegate?
	var defaultContentView: UIListContentView?
	var shouldConfigureStackView = true
//	var song: Song?
	
	var section: Int? {
		didSet {
//            if self.section == 0 {
//                holdView.addSubview(closeButton)
//                closeButton.anchor(centerX: holdView.centerXAnchor, centerY: holdView.centerYAnchor, size: .init(width: 30, height: 30))
//            } else if self.section == 1 {
//                holdView.addSubview(iconImageView)
//                iconImageView.anchor(centerX: holdView.centerXAnchor, centerY: holdView.centerYAnchor, size: .init(width: 30, height: 30))
//            }
//            updateConfiguration(using: self.configurationState)
		}
	}
	let iconImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.clipsToBounds = true
		imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		imageView.tintColor = .white
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()
	
	let holdView: UIView = {
		let view = UIView()
		view.backgroundColor = .clear
		view.translatesAutoresizingMaskIntoConstraints = false
		view.setSize(width: 50, height: 50)
		view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		return view
	}()
	
	lazy var closeButton: UIButton = {
		let button = UIButton(type: .close)
		button.addTarget(self, action: #selector(dismissSettingsVC), for: .touchUpInside)
		return button
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)

	}
	
	required init?(coder: NSCoder) {
		fatalError("storyboard is trash")
	}
	
	private func configureStackView() {
		let config = defaultContentConfiguration()
		let defaultView = UIListContentView(configuration: config)
		defaultView.translatesAutoresizingMaskIntoConstraints = false
		self.defaultContentView = defaultView
		let stackView = UIStackView(arrangedSubviews: [defaultView, holdView])
		stackView.alignment = .center
		stackView.axis = .horizontal
		stackView.distribution = .fill
		contentView.addSubview(stackView)
//        let height = stackView.heightAnchor.constraint(equalToConstant: 50)
//		height.priority = UILayoutPriority(999)
		stackView.translatesAutoresizingMaskIntoConstraints = false
		let top = stackView.topAnchor.constraint(equalTo: contentView.topAnchor)
		top.priority = UILayoutPriority(999)
		let leading = stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
		leading.priority = UILayoutPriority(999)
		let trailing = stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
		trailing.priority = UILayoutPriority(999)
		let bottom = stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		bottom.priority = UILayoutPriority(999)
		
		
		NSLayoutConstraint.activate([
			top,
			leading,
			trailing,
			bottom
		])
//		stackViewConstraints(stackView: stackView, contentView: contentView)
	}
	
	private func setting(for settingType: SettingType) {
		if shouldConfigureStackView {
			configureStackView()
			shouldConfigureStackView = false
		}
		if self.section == 0 {
			holdView.addSubview(closeButton)
			closeButton.anchor(centerX: holdView.centerXAnchor, centerY: holdView.centerYAnchor, size: .init(width: 30, height: 30))
		} else if self.section == 1 {
			holdView.addSubview(iconImageView)
			iconImageView.anchor(centerX: holdView.centerXAnchor, centerY: holdView.centerYAnchor, size: .init(width: 30, height: 30))
		}
		updateConfiguration(using: self.configurationState)
	}
	
	private func makeContentViewConfiguration() -> UIListContentConfiguration {
		var config = defaultContentConfiguration()
//		var bgConfig = UIBackgroundConfiguration.listGroupedCell().updated(for: self.configurationState)
//		bgConfig.backgroundColor = .backgroundColor
//		backgroundConfiguration = bgConfig
//        background(for: self.settingType ?? .playlistSetting, section: section ?? 0)
//        config.directionalLayoutMargins = NSDirectionalEdgeInsets(top: -8, leading: 20, bottom: 8, trailing: 20)
		
		switch settingType {
		case .searchedSongSetting:
			switch section {
			case 0:
				let searchedSong = setting?.setting as! SettingsObject
				if case SettingsObject.song(let song) = searchedSong {
					config.textProperties.color = .lightText
					config.textProperties.font = UIFont.preferredFont(forTextStyle: .subheadline)
					config.secondaryTextProperties.color = .white
					config.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .subheadline)
					config.textToSecondaryTextVerticalPadding = 0
					config.imageToTextPadding = 8
					config.text = song.artistName
					config.secondaryText = song.songName
					config.image = UIImage(data: song.albumArtwork ?? Data())
					config.imageProperties.maximumSize = CGSize(width: UIScreen.main.bounds.width / 10, height: UIScreen.main.bounds.width / 10)
				}
			case 1:
				let songOption = setting?.setting as! SearchedSongSetting
				config.textProperties.color = .white
				config.textProperties.font = UIFont.preferredFont(forTextStyle: .headline)
				config.text = songOption.description
				iconImageView.image = songOption.image
			default:
				break
			}
		case .playlistSetting:
			switch section {
			case 0:
				let playlistSetting = setting?.setting as! SettingsObject
				config.textProperties.color = .white
				config.textProperties.font = UIFont.preferredFont(forTextStyle: .headline)
//                config.textProperties.alignment = .center
				config.text = playlistSetting.description
//                config.imageProperties.maximumSize = CGSize(width: UIScreen.main.bounds.width / 10, height: UIScreen.main.bounds.width / 10)
//                config.image = UIImage()
			case 1:
				let playlistSetting = setting?.setting as! PlaylistSetting
				config.textProperties.color = .white
				config.textProperties.font = UIFont.preferredFont(forTextStyle: .headline)
				config.text = playlistSetting.description
				iconImageView.image = playlistSetting.image
			default:
				break
			}
		default:
			 break
		}
		return config
	}
	
//	private func background(for settingType: SettingType, section: Int) {
//		switch settingType {
//		case .searchedSongSetting:
//			var bgConfig = UIBackgroundConfiguration.listGroupedCell().updated(for: self.configurationState)
//			bgConfig.backgroundColor = .backgroundColor
//			backgroundConfiguration = bgConfig
//		case .playlistSetting:
//			switch section {
//			case 0:
//				var bgConfig = UIBackgroundConfiguration.listGroupedCell().updated(for: self.configurationState)
//				bgConfig.backgroundColor = .clear
//				backgroundConfiguration = bgConfig
//			case 1:
//				var bgConfig = UIBackgroundConfiguration.listGroupedCell().updated(for: self.configurationState)
//				bgConfig.backgroundColor = .backgroundColor
//				backgroundConfiguration = bgConfig
//			default:
//				break
//			}
//		case .addToExistingPlaylist:
//			()
//		}
//	}
	
	override func updateConfiguration(using state: UICellConfigurationState) {
		defaultContentView?.configuration = makeContentViewConfiguration()
		if state.isHighlighted {
			var bgConfig = UIBackgroundConfiguration.listGroupedCell().updated(for: state)
			bgConfig.backgroundColorTransformer = .preferredTint
			backgroundConfiguration = bgConfig
		} else {
			var bgConfig = UIBackgroundConfiguration.listGroupedCell().updated(for: state)
			bgConfig.backgroundColor = .backgroundColor
			backgroundConfiguration = bgConfig
		}
		if section == 0 {
			var bgConfig = UIBackgroundConfiguration.listGroupedCell().updated(for: state)
			bgConfig.backgroundColor = .backgroundColor
			backgroundConfiguration = bgConfig
		}
	}
	
	@objc private func dismissSettingsVC() {
		settingsDelegate?.dismissVC()
	}
}
