//
//  LinearGradient+Init.swift
//  New-Music
//
//  Created by Michael McGrath on 10/6/20.
//

import SwiftUI

extension LinearGradient {
    init(direction: GradientDirection, _ colors: Color...) {
        switch direction {
        case .diagonalTopToBottom:
            self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
        case .leadingToTrailing:
            self.init(gradient: Gradient(colors: colors), startPoint: .leading, endPoint: .trailing)
        case .topTrailingBottomLeading:
            self.init(gradient: Gradient(colors: colors), startPoint: .topTrailing, endPoint: .bottomLeading)
        }
    }
}

