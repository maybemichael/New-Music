//
//  LinearGradient+Init.swift
//  New-Music
//
//  Created by Michael McGrath on 10/6/20.
//

import SwiftUI

extension LinearGradient {
    init(_ colors: Color...) {
        self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

