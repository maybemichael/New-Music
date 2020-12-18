//
//  NowPlayingIndictorView2.swift
//  New-Music
//
//  Created by Michael McGrath on 12/18/20.
//

import UIKit
import Combine

class NowPlayingIndictorView2: UIView {
    
    private var cancellable: AnyCancellable?
    private var nowPlayingViewModel: NowPlayingViewModel
    var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .clear
        return iv
    }()
    
    var gradientLayer: CAGradientLayer?
    
    override public class var layerClass: Swift.AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let image = UIImage(systemName: "music.note")
        imageView.frame = bounds
        self.imageView = UIImageView(image: image?.applyingSymbolConfiguration(UIImage.SymbolConfiguration.init(pointSize: 40, weight: .semibold, scale: .default)))
        self.mask = imageView
    }
    
    init(frame: CGRect, nowPlayingViewModel: NowPlayingViewModel) {
        self.nowPlayingViewModel = nowPlayingViewModel
        super.init(frame: frame)
        createGradientLayer(color1: nowPlayingViewModel.lighterUIColor, color2: nowPlayingViewModel.darkerUIColor)
        layer.masksToBounds = false
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        addSubview(imageView)
        imageView.frame = self.bounds
        
        cancellable = nowPlayingViewModel.$darkerUIColor.sink { [weak self] color1 in
            guard let self = self else { return }
            self.changeGradient()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("storyboard is not your friend")
    }
    
    private func createGradientLayer(color1: UIColor, color2: UIColor) {
        let gradient = CAGradientLayer()
        gradient.colors = [color1.cgColor, color2.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.frame = bounds
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        layer.addSublayer(gradient)
        gradient.setNeedsDisplay()
        self.gradientLayer = gradient
    }
    
    private func changeGradient() {
        gradientLayer?.removeFromSuperlayer()
        createGradientLayer(color1: nowPlayingViewModel.lighterUIColor, color2: nowPlayingViewModel.darkerUIColor)
    }
}
