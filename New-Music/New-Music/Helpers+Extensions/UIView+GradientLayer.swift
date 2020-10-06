//
//  UIView+GradientLayer.swift
//  New-Music
//
//  Created by Michael McGrath on 10/5/20.
//

import UIKit

extension UIView {
    func addGradientToButton(color1: UIColor, color2: UIColor) {
        let gradientlayer = CAGradientLayer()
        gradientlayer.colors = [color1.cgColor, color2.cgColor]
        gradientlayer.locations = [0.0, 1.0]
        gradientlayer.frame = bounds
        gradientlayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientlayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        layer.insertSublayer(gradientlayer, at: 0)
    }
}
