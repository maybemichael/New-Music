//
//  PlayPlaylistButton.swift
//  New-Music
//
//  Created by Michael McGrath on 11/27/20.
//

import UIKit

class NeuMusicButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Hooray Storyboard")
    }
    
    private func gradientLayer() {
        let gradientlayer = CAGradientLayer()
//        gradientlayer.colors = [UIColor.darkGray.cgColor, UIColor.darkGray.darker().cgColor]
        gradientlayer.colors = [UIColor.systemGray4.cgColor, UIColor.systemGray5.cgColor]
        gradientlayer.locations = [0.0, 1.0]
        gradientlayer.frame = bounds
        gradientlayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientlayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        layer.insertSublayer(gradientlayer, at: 0)
    }
}
