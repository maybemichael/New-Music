//
//  NowPlayingViewState.swift
//  New-Music
//
//  Created by Michael McGrath on 10/18/20.
//

import SwiftUI

enum NowPlayingViewState {
    case minimized
    case full
    
    func nowPlayingViewHeight() -> CGFloat {
        switch self {
        case .minimized:
            return 80
        case .full:
            return UIScreen.main.bounds.height
        }
    }
    
    func isFullScreen() -> Bool {
        switch self {
        case .minimized:
            return false
        case .full:
            return true
        }
    }
    mutating func toggleFullScreen() {
        switch self {
        case .minimized:
            self = .minimized
        case .full:
            self = .full
        }
    }
}
