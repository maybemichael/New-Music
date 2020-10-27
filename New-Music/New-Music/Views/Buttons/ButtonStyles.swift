//
//  ButtonStyles.swift
//  New-Music
//
//  Created by Michael McGrath on 10/26/20.
//

import SwiftUI

//struct NeuButtonStyle: ButtonStyle {
//    @EnvironmentObject var songViewModel: NowPlayingViewModel
//    var lighterColor: Color
//    var darkerColor: Color
//    var size: CGFloat
//    
//    func makeBody(configuration: Self.Configuration) -> some View {
//        configuration.label
//            .padding(30)
//            .contentShape(Circle())
//            .background(NeuButtonBackground(isHighlighted: configuration.isPressed, shape: Circle(), size: size))
//    }
//}

//struct ToggleButtonStyle: ToggleStyle {
//    @EnvironmentObject var songViewModel: NowPlayingViewModel
//    var musicController: MusicController
//    var size: CGFloat
//    var labelPadding: CGFloat
//
//    func makeBody(configuration: Self.Configuration) -> some View {
//        Button(action: {
//            songViewModel.isPlaying.toggle()
//            configuration.isOn = songViewModel.isPlaying ? true : false
//            configuration.isOn ? musicController.play() : musicController.pause()
//        }) {
//            configuration.label
//                .padding(labelPadding)
//                .contentShape(Circle())
//                .background(NeuToggleBackground(shape: Circle(), lighterColor: songViewModel.lighterAccentColor, darkerColor: songViewModel.darkerAccentColor, size: size))
//        }
//    }
//}
