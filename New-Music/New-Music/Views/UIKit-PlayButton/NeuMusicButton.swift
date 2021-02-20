//
//  PlayPlaylistButton.swift
//  New-Music
//
//  Created by Michael McGrath on 11/27/20.
//

import UIKit

class NeuMusicButton: UIButton {

    var gradientLayer: CAGradientLayer?
    var isGradientAdded = false
    override var isHighlighted: Bool {
        didSet {
            animationOnButtonTapped()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !isGradientAdded {
            createGradientLayer()
        }
        gradientColors(for: self.isHighlighted)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Hooray Storyboard")
    }
    
    private func createGradientLayer() {
        let gradientlayer = CAGradientLayer()
        gradientlayer.colors = [UIColor.systemGray4.cgColor, UIColor.systemGray5.cgColor]
//        gradientlayer.colors = [UIColor.systemGray4.cgColor, UIColor.systemGray4.darker(componentDelta: 0.075).cgColor]
        gradientlayer.locations = [0.0, 1.0]
        gradientlayer.frame = bounds
        gradientlayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientlayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        layer.insertSublayer(gradientlayer, below: self.imageView?.layer)
        self.gradientLayer = gradientlayer
    }
    
    private func animationOnButtonTapped() {
        if isHighlighted {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear) { [weak self] in
                self?.transform = CGAffineTransform(scaleX: 0.93, y: 0.93)
                self?.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear) { [weak self] in
                self?.transform = .identity
                self?.layoutIfNeeded()
            }
        }
    }
    
    private func gradientColors(for state: Bool) {
        if isHighlighted {
            gradientLayer?.colors = [UIColor.systemGray5.cgColor, UIColor.systemGray4.cgColor]
//            gradientLayer?.colors = [UIColor.systemGray4.darker(componentDelta: 0.075).cgColor, UIColor.systemGray4.cgColor]
        } else {
            gradientLayer?.colors = [UIColor.systemGray4.cgColor, UIColor.systemGray5.cgColor]
//            gradientLayer?.colors = [UIColor.systemGray4.cgColor, UIColor.systemGray4.darker(componentDelta: 0.075).cgColor]
        }
    }
}
