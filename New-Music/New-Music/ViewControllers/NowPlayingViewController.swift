//
//  NowPlayingViewController.swift
//  New-Music
//
//  Created by Michael McGrath on 10/3/20.
//

import UIKit
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
    
    var musicController: MusicController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMusicControlls()
        setUpMediaViews()
        view.backgroundColor = .backgroundColor
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
    
    private func configureMusicControlls() {
        view.addSubview(musicControlView)
        musicControlView.frame = CGRect(x: view.bounds.minX, y: view.bounds.minY + 600, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 7)
//        musicControlView.anchor(leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, size: .init(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 7))
        musicControlView.backgroundColor = .clear
        playButton.setImage(UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 15, weight: .black)), for: .normal)
        playButton.setImage(UIImage(systemName: "pause.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 15, weight: .black)), for: .selected)
        playButton.addTarget(self, action: #selector(playButtonTapped(_:)), for: .touchUpInside)
        trackForwardButton.addTarget(self, action: #selector(trackForwardTapped(_:)), for: .touchUpInside)
        trackBackwardButton.addTarget(self, action: #selector(trackBackwardTapped(_:)), for: .touchUpInside)
        trackForwardButton.setImage(UIImage(systemName: "forward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)), for: .normal)
        trackBackwardButton.setImage(UIImage(systemName: "backward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)), for: .normal)
        playButton.tintColor = .white
        trackForwardButton.tintColor = .white
        trackBackwardButton.tintColor = .white
        let stackView = UIStackView(arrangedSubviews: [trackBackwardButton, playButton, trackForwardButton])
        stackView.axis = .horizontal
        musicControlView.addSubview(stackView)
        stackView.anchor(top: musicControlView.topAnchor, leading: musicControlView.leadingAnchor, trailing: musicControlView.trailingAnchor, bottom: musicControlView.bottomAnchor, padding: .init(top: 12, left: 12, bottom: -12, right: -12))
        stackView.distribution = .fillEqually
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
//        imageView.contentMode = .scaleAspectFit
        imageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.centerYAnchor, centerX: view.centerXAnchor, padding: .init(top: 80, left: 20, bottom: 20, right: -20))
        artist.anchor(top: imageView.bottomAnchor, leading: imageView.leadingAnchor, trailing: imageView.trailingAnchor, centerX: view.centerXAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0))
        songTitle.anchor(top: artist.bottomAnchor, leading: imageView.leadingAnchor, trailing: imageView.trailingAnchor, centerX: view.centerXAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        artist.textAlignment = .center
        songTitle.textAlignment = .center
        artist.text = "Drake"
        songTitle.text = "Hold on were going home"
//        imageView.backgroundColor = .orange
        
        
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

extension UIImage.SymbolConfiguration {
    static var navButtonConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold)
    static var playbackButtonConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold)
}
