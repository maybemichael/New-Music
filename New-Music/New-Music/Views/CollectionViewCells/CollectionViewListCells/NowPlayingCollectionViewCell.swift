//
//  NowPlayingCollectionViewCell.swift
//  New-Music
//
//  Created by Michael McGrath on 12/21/20.
//

import UIKit
import Combine

class NowPlayingCollectionViewCell: UICollectionViewListCell {
    static let identifier = "NowPlayingCell"
    
    var song: Song?
    var nowPlayingViewModel: NowPlayingViewModel? {
        didSet {
            var indicator: NowPlayingIndictorView
            guard let nowPlayingViewModel = self.nowPlayingViewModel else { return }
            if indicatorView == nil {
                indicator = NowPlayingIndictorView(frame: .zero, nowPlayingViewModel: nowPlayingViewModel)
                self.indicatorView = indicator
                holderView.addSubview(indicator)
//                indicator.setSize(width: (UIScreen.main.bounds.width / 7) / 2.25, height: (UIScreen.main.bounds.width / 7) / 2.25)
//                indicator.anchor(centerX: holderView.centerXAnchor, centerY: holderView.centerYAnchor)
                indicator.anchor(top: holderView.topAnchor, leading: holderView.leadingAnchor, trailing: holderView.trailingAnchor, bottom: holderView.bottomAnchor)
            }
        }
    }
    var playID: String?
    private var playIDSubscriber: AnyCancellable?
    private var isPlayingSubscriber: AnyCancellable?
    private var willEnterForegroundSubscriber = Set<AnyCancellable>()
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    var defaultContentView: UIListContentView?
    let holderView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    var indicatorView: NowPlayingIndictorView? {
        didSet {
            playIDSubscriber = nowPlayingViewModel?.$playID.sink(receiveValue: { [weak self] id in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.showNowPlayingIndicator()
                }
            })
            
            isPlayingSubscriber = nowPlayingViewModel?.$isPlaying.sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.showNowPlayingIndicator()
                }
            })
        }
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        backgroundView = containerView
        let config = makeContentConfiguration()
        let defaultView = UIListContentView(configuration: config)
        self.defaultContentView = defaultView
        let stackView = UIStackView(arrangedSubviews: [defaultView, holderView])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        contentView.addSubview(stackView)
        holderView.setSize(width: (UIScreen.main.bounds.width / 7) / 2, height: (UIScreen.main.bounds.width / 7) / 2)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let top = stackView.topAnchor.constraint(equalTo: contentView.topAnchor)
        top.priority = UILayoutPriority(999)
        let leading = stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        leading.priority = UILayoutPriority(999)
        let trailing = stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        trailing.priority = UILayoutPriority(999)
        let bottom = stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        bottom.priority = UILayoutPriority(999)
        NSLayoutConstraint.activate([
            top,
            leading,
            trailing,
            bottom
        ])
        
        var backgroundConfig = UIBackgroundConfiguration.listGroupedCell()
        backgroundConfig.backgroundColor = .clear
        backgroundConfiguration = backgroundConfig
        
        self.separatorLayoutGuide.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: (UIScreen.main.bounds.width / 7) + 28).isActive = true
        nowPlayingViewModel?.isPlaying = nowPlayingViewModel?.musicPlayer.playbackState == .playing
        createWillEnterForegroundListener()
    }
    
    required init?(coder: NSCoder) {
        fatalError("storyboard is trash")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        showNowPlayingIndicator()
    }
    
    private func makeContentConfiguration() -> UIListContentConfiguration {
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
        config.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 0)
        config.secondaryTextProperties.numberOfLines = 2
        config.textToSecondaryTextVerticalPadding = 0
        return config
    }
    
    private func showNowPlayingIndicator() {
        guard let nowPlayingViewModel = self.nowPlayingViewModel else { return }
        if nowPlayingViewModel.nowPlayingSong?.playID == playID {
            indicatorView?.isHidden = false
            animateNowPlayingIndicator()
        } else {
            indicatorView?.isHidden = true
            self.indicatorView?.layer.removeAllAnimations()
        }
    }
    
    private func createWillEnterForegroundListener() {
        let _ = NotificationCenter.default
            .publisher(for: UIApplication.willEnterForegroundNotification, object: nil)
            .sink { [weak self] _ in
                self?.nowPlayingViewModel?.isPlaying = self?.nowPlayingViewModel?.musicPlayer.playbackState == .playing
                self?.showNowPlayingIndicator()
            }
            .store(in: &willEnterForegroundSubscriber)
    }
    
    private func animateNowPlayingIndicator() {
        guard let nowPlayingViewModel = self.nowPlayingViewModel else { return }
        if nowPlayingViewModel.isPlaying {
            if indicatorView?.transform == .identity {
                UIView.animate(withDuration: 0.7, delay: 0, options: [.repeat, .autoreverse, .curveEaseOut]) { [weak self] in
                    guard let self = self else { return }
                    self.indicatorView?.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
                    self.layoutIfNeeded()
                } completion: { [weak self] _ in
                    self?.indicatorView?.transform = .identity
                }
            }
        } else {
            self.indicatorView?.layer.removeAllAnimations()
        }
    }
}
