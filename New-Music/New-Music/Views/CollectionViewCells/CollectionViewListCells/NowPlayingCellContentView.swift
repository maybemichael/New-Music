//
//  NowPlayingCellContentView.swift
//  New-Music
//
//  Created by Michael McGrath on 12/21/20.
//

import UIKit
import Combine

class NowPlayingCellContentView: UIView, UIContentView {
    
    let songTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    let artistLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightText
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textAlignment = .left
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    let holderView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    
    var playID: String?
    private var cancellable: AnyCancellable?
    var indicatorView: NowPlayingIndictorView?
    
    var mainStackView: UIStackView?
    
    var nowPlayingViewModel: NowPlayingViewModel {
        didSet {
            
        }
    }
    
    var labelStackView: UIStackView?
    
    private var currentConfiguration: NowPlayingCellContentConfiguration!
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        }
        
        set {
            guard let newConfig = newValue as? NowPlayingCellContentConfiguration else { return }
            apply(configuration: newConfig)
        }
    }
    
    init(configuration: NowPlayingCellContentConfiguration, nowPlayingViewModel: NowPlayingViewModel) {
        self.nowPlayingViewModel = nowPlayingViewModel
        super.init(frame: .zero)
        setupViews()
        apply(configuration: configuration)
        backgroundColor = .clear
        cancellable = nowPlayingViewModel.$playID.sink { [weak self] id in
            guard let self = self else { return }
            self.indicatorView?.removeFromSuperview()
            self.indicatorView?.layer.removeAllAnimations()
            self.indicatorView = nil
            self.setupIndicatorView()
            self.removeAnimation()
        }
        
//        cancellable = nowPlayingViewModel.$isPlaying.sink { [weak self] isPlaying in
//            guard let self = self else { return }
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("Storyboard is not the best thing in the world")
    }
    
    private func setupViews() {
        addSubview(containerView)
        containerView.setSize(width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.width / 7) + 16)
        let top = containerView.topAnchor.constraint(equalTo: topAnchor)
        top.priority = UILayoutPriority(999)
        let leading = containerView.leadingAnchor.constraint(equalTo: leadingAnchor)
        leading.priority = UILayoutPriority(999)
        let trailing = containerView.trailingAnchor.constraint(equalTo: trailingAnchor)
        trailing.priority = UILayoutPriority(999)
        let bottom = containerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        bottom.priority = UILayoutPriority(999)
        containerView.addSubview(holderView)
        containerView.addSubview(imageView)
        holderView.anchor(trailing: containerView.trailingAnchor, centerY: containerView.centerYAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: -20), size: .init(width: (UIScreen.main.bounds.width / 7) / 2, height: (UIScreen.main.bounds.width / 7) / 2))
        let labelStackView = UIStackView(arrangedSubviews: [artistLabel, songTitleLabel])
        self.labelStackView = labelStackView
        labelStackView.axis = .vertical
        labelStackView.alignment = .leading
        labelStackView.spacing = 0
        labelStackView.distribution = .fillProportionally
        
        imageView.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, padding: .init(top: 8, left: 20, bottom: 0, right: 0), size: .init(width: UIScreen.main.bounds.width / 7, height: UIScreen.main.bounds.width / 7))
        containerView.addSubview(labelStackView)
        labelStackView.anchor(leading: imageView.trailingAnchor, trailing: holderView.leadingAnchor, centerY: containerView.centerYAnchor, padding: .init(top: 0, left: 8, bottom: 0, right: -8))
        NSLayoutConstraint.activate([
            top,
            leading,
            trailing,
            bottom
        ])
    }
    
    private func apply(configuration: NowPlayingCellContentConfiguration) {
        guard currentConfiguration != configuration else { return }
        currentConfiguration = configuration
        songTitleLabel.text = configuration.songTitle
        artistLabel.text = configuration.artist
        nowPlayingViewModel = configuration.nowPlayingViewModel
        playID = configuration.playID
        if let data = configuration.albumArtwork {
            imageView.image = UIImage(data: data)
        }
    }
    
    private func setupIndicatorView() {
        if self.playID == self.nowPlayingViewModel.nowPlayingSong?.playID {            
            self.indicatorView = NowPlayingIndictorView(frame: .zero, nowPlayingViewModel: nowPlayingViewModel)
            self.holderView.addSubview(self.indicatorView!)
            indicatorView?.layer.masksToBounds = false
            self.indicatorView?.anchor(top: self.holderView.topAnchor, leading: self.holderView.leadingAnchor, trailing: self.holderView.trailingAnchor, bottom: self.holderView.bottomAnchor)
            self.layoutIfNeeded()
            UIView.animate(withDuration: 0.8, delay: 0, options: [.repeat, .autoreverse, .curveEaseIn]) { [weak self] in
                guard let self = self else { return }
                self.indicatorView?.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                self.layoutIfNeeded()
            } completion: { [weak self] _ in
                self?.indicatorView?.transform = .identity
            }
        }
    }
    
    private func removeAnimation() {
        if !nowPlayingViewModel.isPlaying {
            self.indicatorView?.layer.removeAllAnimations()
            self.layoutIfNeeded()
        }
    }
}

struct NowPlayingCellContentConfiguration: UIContentConfiguration, Hashable {
    static func == (lhs: NowPlayingCellContentConfiguration, rhs: NowPlayingCellContentConfiguration) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id = UUID().uuidString
    var nowPlayingViewModel: NowPlayingViewModel
    var songTitle: String?
    var artist: String?
    var albumArtwork: Data?
    var playID: String?
    
    func makeContentView() -> UIView & UIContentView {
        return NowPlayingCellContentView(configuration: self, nowPlayingViewModel: nowPlayingViewModel)
    }
    
    func updated(for state: UIConfigurationState) -> NowPlayingCellContentConfiguration {
        return self
    }
}
