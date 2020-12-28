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
    
    var gradientLayer: CAGradientLayer?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let image = UIImage(systemName: "music.note")
        imageView.frame = bounds
        self.imageView = UIImageView(image: image?.applyingSymbolConfiguration(UIImage.SymbolConfiguration.init(pointSize: imageView.bounds.height * 0.93, weight: .semibold, scale: .default)))
        self.mask = imageView
    }
    
    init(frame: CGRect, nowPlayingViewModel: NowPlayingViewModel) {
        self.nowPlayingViewModel = nowPlayingViewModel
        super.init(frame: frame)
        layer.masksToBounds = false
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        addSubview(imageView)
        imageView.frame = self.bounds
        
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
        
        let image = UIImage(systemName: "music.note")
        imageView.frame = bounds
        self.imageView = UIImageView(image: image?.applyingSymbolConfiguration(UIImage.SymbolConfiguration.init(pointSize: imageView.bounds.height * 0.93, weight: .semibold, scale: .default)))
        self.mask = imageView
        layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("storyboard is not your friend")
    }
}
