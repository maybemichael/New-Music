//
//  CurrentPlaylistCellViewController.swift
//  New-Music
//
//  Created by Michael McGrath on 11/17/20.
//

import SwiftUI

class CurrentPlaylistCellViewController: UIViewController {

    var musicController: MusicController
    var song: Song? {
        didSet {
            configureSubviews()
            updateViews()
        }
    }
    var nowPlayingIndicator: UIViewController?
    
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
    let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 7
        imageView.clipsToBounds = true
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageView.setSize(width: UIScreen.main.bounds.width / 6, height: UIScreen.main.bounds.width / 6)
        return imageView
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGrayThree
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
    
    lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [artistLabel, songTitleLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        configureSubviews()
//        setUpViews()
        updateViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateViews()
    }
    
    private func addSubviews() {
        self.nowPlayingIndicator = UIHostingController(rootView: MusicNoteView(size: UIScreen.main.bounds.width / 10).environmentObject(musicController.nowPlayingViewModel))
        self.nowPlayingIndicator?.view.backgroundColor = .clear
        addChild(self.nowPlayingIndicator!)
        self.nowPlayingIndicator?.didMove(toParent: self)
//        self.nowPlayingIndicator?.view.setSize(width: UIScreen.main.bounds.width / 7.5, height: UIScreen.main.bounds.width / 7.5)
        [albumImageView, labelStackView, nowPlayingIndicator!.view, separatorView].forEach { view.addSubview($0) }
    }
    
    private func configureSubviews() {
        let innerStackView = UIStackView(arrangedSubviews: [artistLabel, songTitleLabel])
        innerStackView.axis = .vertical
        let outerStackView = UIStackView(arrangedSubviews: [albumImageView, innerStackView, self.nowPlayingIndicator!.view])
        outerStackView.alignment = .center
        outerStackView.distribution = .fill
        outerStackView.spacing = 8
        let mainStackView = UIStackView(arrangedSubviews: [outerStackView, separatorView])
        mainStackView.axis = .vertical
        mainStackView.distribution = .equalCentering
        mainStackView.spacing = 8
        view.addSubview(mainStackView)
        mainStackView.frame = view.bounds
    }
    
    private func setUpViews() {
//        let innerStackView = UIStackView(arrangedSubviews: [artistLabel, songTitleLabel])
//        innerStackView.axis = .vertical
//        self.nowPlayingIndicator = UIHostingController(rootView: MusicNoteView().environmentObject(musicController.nowPlayingViewModel))
//        self.nowPlayingIndicator?.view.backgroundColor = .clear
//        addChild(self.nowPlayingIndicator!)
//        self.nowPlayingIndicator?.didMove(toParent: self.nowPlayingIndicator)
//        let outerStackView = UIStackView(arrangedSubviews: [albumImageView, innerStackView, self.nowPlayingIndicator!.view])
//        outerStackView.alignment = .center
//        outerStackView.distribution = .fill
//        outerStackView.spacing = 10
//        let mainStackView = UIStackView(arrangedSubviews: [outerStackView, separatorView])
//        mainStackView.axis = .vertical
//        mainStackView.distribution = .equalCentering
//        mainStackView.spacing = 8
//        view.addSubview(mainStackView)
//        mainStackView.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    private func updateViews() {
        guard let song = song else { return }
        artistLabel.text = song.artistName
        songTitleLabel.text = song.songName
        if let imageData = song.albumArtwork {
            albumImageView.image = UIImage(data: imageData)
        }
    }
    
    init(musicController: MusicController) {
        self.musicController = musicController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("No storyboards...")
    }
}
