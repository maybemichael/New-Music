//
//  GetFrameViewModifier.swift
//  New-Music
//
//  Created by Michael McGrath on 12/17/20.
//

import SwiftUI

struct GetFrameModifier: ViewModifier {
    private var frameView: some View {
        GeometryReader { geo in
            Color.clear.preference(key: FramePreferenceKey.self, value: geo.frame(in: .global))
        }
        .frame(width: UIScreen.main.bounds.width - 80, height: UIScreen.main.bounds.width - 80, alignment: .center)
    }
    
    func body(content: Content) -> some View {
        content.background(frameView)
    }
}

struct FramePreferenceKey: PreferenceKey {
    typealias Value = CGRect
    
    static var defaultValue: Value = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
