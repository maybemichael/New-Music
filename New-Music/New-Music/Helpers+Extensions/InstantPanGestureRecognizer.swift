//
//  InstantPanGestureRecognizer.swift
//  New-Music
//
//  Created by Michael McGrath on 11/6/20.
//

import UIKit

class InstantPanGestureRecognizer: UIPanGestureRecognizer {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if self.state == .began { return }
        super.touchesBegan(touches, with: event)
        self.state = .began
    }
}
