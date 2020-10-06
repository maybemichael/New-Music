//
//  NowPlayingViewController.swift
//  New-Music
//
//  Created by Michael McGrath on 10/3/20.
//

import SwiftUI
import MediaPlayer

class NowPlayingViewController: UIViewController {

    let imageView = UIImageView()
    let playButton = UIButton()
    let trackForwardButton = UIButton()
    let trackBackwardButton = UIButton()
    let musicControlView = UIView()
    let artist = UILabel()
    let songTitle = UILabel()
    var isPlaying = false
    var contentView = UIHostingController(rootView: NowPlayingView(viewModel: NowPlayingViewModel(musicController: MusicController.shared)))
    var musicController: MusicController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMusicControlls()
        setUpMediaViews()
        view.backgroundColor = .backgroundColor
        addChild(contentView)
        view.addSubview(contentView.view)
        contentView.view.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if musicController.isPlaying {
            updateViews()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        trackBackwardButton.layer.cornerRadius = trackBackwardButton.bounds.width / 2
        trackForwardButton.layer.cornerRadius = trackForwardButton.bounds.width / 2
        playButton.layer.cornerRadius = playButton.bounds.width / 2
    }
    
    private func configureMusicControlls() {
        view.addSubview(musicControlView)
        musicControlView.anchor(leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, padding: .init(top: 0, left: 0, bottom: -20, right: 0), size: .init(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 7))
        musicControlView.backgroundColor = .clear
        playButton.setImage(UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration.musicControlConfig), for: .normal)
        playButton.setImage(UIImage(systemName: "pause.fill", withConfiguration: UIImage.SymbolConfiguration.musicControlConfig), for: .selected)
        playButton.addTarget(self, action: #selector(playButtonTapped(_:)), for: .touchUpInside)
        trackForwardButton.addTarget(self, action: #selector(trackForwardTapped(_:)), for: .touchUpInside)
        trackBackwardButton.addTarget(self, action: #selector(trackBackwardTapped(_:)), for: .touchUpInside)
        trackForwardButton.setImage(UIImage(systemName: "forward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)), for: .normal)
        trackBackwardButton.setImage(UIImage(systemName: "backward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)), for: .normal)
        playButton.backgroundColor = .systemGraySix
        trackForwardButton.backgroundColor = .systemGraySix
        trackBackwardButton.backgroundColor = .systemGraySix
        trackBackwardButton.clipsToBounds = true
        musicControlView.addSubview(playButton)
        musicControlView.addSubview(trackBackwardButton)
        musicControlView.addSubview(trackForwardButton)
        playButton.anchor(centerX: musicControlView.centerXAnchor, centerY: musicControlView.centerYAnchor, size: .init(width: 85, height: 85))
        trackForwardButton.anchor(leading: playButton.trailingAnchor, centerY: musicControlView.centerYAnchor, padding: .init(top: 20, left: 20, bottom: -20, right: -20), size: .init(width: 75, height: 75))
        trackBackwardButton.anchor(top: nil, leading: nil, trailing: playButton.leadingAnchor, bottom: nil, centerX: nil, centerY: musicControlView.centerYAnchor, padding: .init(top: 20, left: 20, bottom: -20, right: -20), size: .init(width: 75, height: 75))
        trackBackwardButton.clipsToBounds = true
        trackForwardButton.clipsToBounds = true
        playButton.clipsToBounds = true
        playButton.tintColor = .white
        trackForwardButton.tintColor = .white
        trackBackwardButton.tintColor = .white
        trackForwardButton.addGradientToButton(color1: UIColor(displayP3Red: 0.557, green: 0.557, blue: 0.578, alpha: 1), color2: UIColor(displayP3Red: 0.173, green: 0.173, blue: 0.176, alpha: 1))
        trackBackwardButton.addGradientToButton(color1: UIColor(displayP3Red: 0.557, green: 0.557, blue: 0.578, alpha: 1), color2: UIColor(displayP3Red: 0.173, green: 0.173, blue: 0.176, alpha: 1))
        playButton.addGradientToButton(color1: UIColor(displayP3Red: 0.557, green: 0.557, blue: 0.578, alpha: 1), color2: UIColor(displayP3Red: 0.173, green: 0.173, blue: 0.176, alpha: 1))


//        let stackView = UIStackView(arrangedSubviews: [trackBackwardButton, playButton, trackForwardButton])
//        stackView.axis = .horizontal
//        musicControlView.addSubview(stackView)
//        stackView.anchor(top: musicControlView.topAnchor, leading: musicControlView.leadingAnchor, trailing: musicControlView.trailingAnchor, bottom: musicControlView.bottomAnchor, padding: .init(top: 12, left: 12, bottom: -12, right: -12))
//        stackView.distribution = .fillEqually
    }
    
    func setUpMediaViews() {
        view.addSubview(imageView)
        view.addSubview(artist)
        view.addSubview(songTitle)
        artist.font = UIFont.preferredFont(forTextStyle: .headline).withSize(20)
        artist.textColor = .white
        songTitle.font = UIFont.preferredFont(forTextStyle: .subheadline).withSize(17)
        songTitle.textColor = .lightText
        songTitle.numberOfLines = 0
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        imageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.centerYAnchor, centerX: view.centerXAnchor, padding: .init(top: 80, left: 20, bottom: 20, right: -20))
        artist.anchor(top: imageView.bottomAnchor, leading: imageView.leadingAnchor, trailing: imageView.trailingAnchor, centerX: view.centerXAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0))
        songTitle.anchor(top: artist.bottomAnchor, leading: imageView.leadingAnchor, trailing: imageView.trailingAnchor, centerX: view.centerXAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        artist.textAlignment = .center
        songTitle.textAlignment = .center
    }
    
    @objc func playButtonTapped(_ playButton: UIButton) {

        musicController.isPlaying.toggle()
        if musicController.isPlaying {
            playButton.isSelected = true
            musicController.play()
        } else {
            playButton.isSelected = false
            musicController.pause()
        }
    }
    
    func updateViews() {
        let index = musicController.musicPlayer.indexOfNowPlayingItem

        let song = musicController.currentPlaylist[index]
        print("Image URL: \(song.imageURL)")
        
        APIController.shared.fetchImage(url: song.imageURL) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            case .failure(let error):
                print("Error fetching image: \(error.localizedDescription)")
            }
        }
        artist.text = song.artistName
        songTitle.text = song.songName
        
    }
    
    @objc func trackForwardTapped(_ trackForward: UIButton) {
        musicController.nextTrack()
    }
    
    @objc func trackBackwardTapped(_ trackBackward: UIButton) {
        musicController.previousTrack()
    }
}


