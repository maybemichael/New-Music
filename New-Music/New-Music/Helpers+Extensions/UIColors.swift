//
//  UIColors.swift
//  New-Music
//
//  Created by Michael McGrath on 10/3/20.
//

import UIKit

extension UIColor {
    static let backgroundColor = UIColor(named: "BackgroundColor")
    static let systemGraySix = UIColor(named: "SystemGraySix")
    static let systemGrayThree = UIColor(named: "SystemGrayThree")
    static let nowPlayingBG = UIColor.backgroundColor?.lighter()
    static let lightTextColor = UIColor(named: "LightTextColor")

    func lighter(componentDelta: CGFloat = 0.1) -> UIColor {
        return makeColor(componentDelta: componentDelta)
    }
    
    func darker(componentDelta: CGFloat = 0.2) -> UIColor {
        return makeColor(componentDelta: -1 * componentDelta)
    }
    
    private func add(_ value: CGFloat, toComponent: CGFloat) -> CGFloat {
        return max(0, min(1, toComponent + value))
    }
    
    private func makeColor(componentDelta: CGFloat) -> UIColor {
        var red: CGFloat = 0
        var blue: CGFloat = 0
        var green: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(
            &red,
            green: &green,
            blue: &blue,
            alpha: &alpha
        )

        return UIColor(
            red: add(componentDelta, toComponent: red),
            green: add(componentDelta, toComponent: green),
            blue: add(componentDelta, toComponent: blue),
            alpha: alpha
        )
    }
}
