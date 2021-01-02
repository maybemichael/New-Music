//
//  NowPlayingIndictorView2.swift
//  New-Music
//
//  Created by Michael McGrath on 12/18/20.
//

import UIKit
import Combine

class NowPlayingIndictorView: UIView {
    
    private var cancellable: AnyCancellable?
    private var nowPlayingViewModel: NowPlayingViewModel
    var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .clear
        return iv
    }()
    
    private var playIDSubscriber: AnyCancellable?
    private var isPlayingSubscriber: AnyCancellable?
    private var image: UIImage?
    var gradientLayer: CAGradientLayer?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let image = UIImage(systemName: "music.note")
        imageView.frame = bounds
        self.imageView = UIImageView(image: image?.applyingSymbolConfiguration(UIImage.SymbolConfiguration.init(pointSize: imageView.bounds.height * 0.9, weight: .semibold, scale: .default)))
        imageView.image = image
        self.mask = imageView
    }
    
    init(frame: CGRect, nowPlayingViewModel: NowPlayingViewModel) {
        self.nowPlayingViewModel = nowPlayingViewModel
        super.init(frame: frame)
        layer.masksToBounds = false
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        addSubview(imageView)
        imageView.frame = bounds
        let image = UIImage(systemName: "music.note")?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: self.bounds.height * 0.9, weight: .semibold, scale: .default))
        self.image = image
        imageView.image = image
        self.imageView = UIImageView(image: image)
        self.mask = imageView
        cancellable = nowPlayingViewModel.$lighterUIColor.sink(receiveValue: { [weak self] color in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if nowPlayingViewModel.whiteLevel < 0.15 {
                    self.backgroundColor = nowPlayingViewModel.lighterTextColor2
                } else {
                    self.backgroundColor = color
                }
                self.layoutIfNeeded()
            }
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("storyboard is not your friend")
    }
}
