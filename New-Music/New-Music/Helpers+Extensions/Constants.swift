//
//  Constants.swift
//  New-Music
//
//  Created by Michael McGrath on 10/9/20.
//

import SwiftUI

enum TrackDirection {
    case trackForward
    case trackBackward
}

enum CardPosition: Double {
    case top = 1.0
    case middle = 0.5
    case bottom = 0.0
    
    var offset: CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        return screenHeight - (screenHeight * CGFloat(self.rawValue))
    }
}

enum DragState {
    case inactive
    case dragging(translation: CGSize)
    
    var translation: CGSize {
        switch self {
        case .inactive:
            return .zero
        case .dragging(let translation):
            return translation
        }
    }
    
    var isDragging: Bool {
        switch self {
        case .inactive:
            return false
        case .dragging:
            return true
        }
    }
}
