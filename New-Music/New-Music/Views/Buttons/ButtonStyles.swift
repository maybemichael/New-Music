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

struct NeuButton: ButtonStyle {
    @EnvironmentObject var nowPlayingViewModel: NowPlayingViewModel
    var size: CGFloat
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .contentShape(Circle())
            .background(NeuTrackButtonBackground(isHighlighted: configuration.isPressed, size: size))
            .frame(width: size, height: size)
            .transition(.move(edge: .bottom))
            .animation(.easeOut(duration: 0.3))
            
    }
}
struct NeuTrackButtonBackground: View {
    @EnvironmentObject var nowPlayingViewModel: NowPlayingViewModel
    @State var isHighlighted: Bool
    var size: CGFloat
    var body: some View {
        ZStack {
            if isHighlighted {

                Circle()
                    .fill(LinearGradient(direction: .diagonalTopToBottom, nowPlayingViewModel.darkerAccentColor, nowPlayingViewModel.lighterAccentColor))
                    .overlay(
                        Circle()
                            .stroke(nowPlayingViewModel.lighterAccentColor, lineWidth: 2)
                            .blur(radius: 4)
                            .offset(x: -2, y: -2)
                            .mask(Circle().fill(LinearGradient(direction: .diagonalTopToBottom, Color.clear, Color.black))))
                    .overlay(
                        Circle()
                            .stroke(nowPlayingViewModel.darkerAccentColor, lineWidth: 2)
                            .blur(radius: 8)
                            .offset(x: -2, y: -2)
                            .mask(Circle().fill(LinearGradient(direction: .diagonalTopToBottom, Color.black, Color.clear))))
                    .shadow(color: Color.black.opacity(0.5), radius: 7, x: 5, y: 5)
                    .shadow(color: Color.white.opacity(0.5), radius: 7, x: -5, y: -5)
                    .blendMode(.overlay)
                Circle()
                    .fill(LinearGradient(direction: .diagonalTopToBottom, nowPlayingViewModel.darkerAccentColor, nowPlayingViewModel.lighterAccentColor))
                    .overlay(Circle().stroke(LinearGradient(direction: .diagonalTopToBottom, .blackGradient, .black), lineWidth: 2))
            } else {
                Circle()
                    .fill(LinearGradient(direction: .diagonalTopToBottom, nowPlayingViewModel.lighterAccentColor, nowPlayingViewModel.darkerAccentColor))
                    .shadow(color: Color.black.opacity(0.5), radius: 10, x: 5, y: 5)
                    .shadow(color: Color.white.opacity(0.5), radius: 10, x: -5, y: -5)
                    .blendMode(.overlay)
                Circle()
                    .fill(LinearGradient(direction: .diagonalTopToBottom, nowPlayingViewModel.lighterAccentColor, nowPlayingViewModel.darkerAccentColor))
                    .overlay(Circle().stroke(LinearGradient(direction: .diagonalTopToBottom, .blackGradient, .black), lineWidth: 2))
            }
        }
        .frame(width: size, height: size)
//        .scaleEffect(isHighlighted ? 0.99999 : 1)
        .animation(.spring())
        .transition(.move(edge: .bottom))
        .animation(.easeOut(duration: 0.3))
    }
}

struct BarToggleButtonStyle: ToggleStyle {
    @EnvironmentObject var nowPlayingViewModel: NowPlayingViewModel
    var musicController: MusicController
    var size: CGFloat
    var labelPadding: CGFloat

    func makeBody(configuration: Self.Configuration) -> some View {
        Button(action: {
            nowPlayingViewModel.isPlaying.toggle()
            configuration.isOn = nowPlayingViewModel.isPlaying ? true : false
            configuration.isOn ? musicController.play() : musicController.pause()
        }) {
            configuration.label
                .padding(labelPadding)
                .contentShape(Circle())
                .background(BarToggleBackground(shape: Circle(), size: size))
        }
    }
}

struct BarToggleBackground<S: Shape>: View {
    @EnvironmentObject var nowPlayingViewModel: NowPlayingViewModel
    var shape: S
    var size: CGFloat
    
    var body: some View {
        ZStack {
            Color.clear
                .edgesIgnoringSafeArea(.all)
            if nowPlayingViewModel.whiteLevel < 0.3 {
                shape
                    .fill(gradient(for: nowPlayingViewModel.isPlaying))
                    .shadow(color: Color.white.opacity(0.15), radius: 10, x: -2, y: -2)
                    .shadow(color: Color.black.opacity(0.5), radius: 10, x: 2, y: 2)
                    .blendMode(.overlay)
                shape
                    .fill(gradient(for: nowPlayingViewModel.isPlaying))
                    .overlay(shape.stroke(LinearGradient(direction: .diagonalTopToBottom, .blackGradient, .black), lineWidth: 2))
            } else {
                shape
                    .fill(gradient(for: nowPlayingViewModel.isPlaying))
                    .shadow(color: Color.white.opacity(0.15), radius: 10, x: -2, y: -2)
                    .shadow(color: Color.black.opacity(0.5), radius: 10, x: 2, y: 2)
                    .blendMode(.overlay)
                shape
                    .fill(gradient(for: nowPlayingViewModel.isPlaying))
                    .overlay(shape.stroke(LinearGradient(direction: .diagonalTopToBottom, .blackGradient, .black), lineWidth: 2))
            }
        }
        .frame(width: size, height: size)
        .transition(.move(edge: .bottom))
    }
    private func gradient(for state: Bool) -> LinearGradient {
        state ? LinearGradient(direction: .diagonalTopToBottom, nowPlayingViewModel.darkerAccentColor, nowPlayingViewModel.lighterAccentColor) : LinearGradient(direction: .diagonalTopToBottom, nowPlayingViewModel.lighterAccentColor, nowPlayingViewModel.darkerAccentColor)
    }
}

struct BarTrackButtonStyle: ButtonStyle {
    @EnvironmentObject var nowPlayingViewModel: NowPlayingViewModel
    var size: CGFloat
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(30)
            .contentShape(Circle())
            .background(BarTrackButtonBackground(isHighlighted: configuration.isPressed, shape: Circle(), size: size))
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
    }
}

struct BarTrackButtonBackground<S: Shape>: View {
    @EnvironmentObject var nowPlayingViewModel: NowPlayingViewModel
    var isHighlighted: Bool
    var shape: S
    var size: CGFloat
    
    var body: some View {
        ZStack {
            Color.clear
                .edgesIgnoringSafeArea(.all)
            if nowPlayingViewModel.whiteLevel < 0.3 {
                if isHighlighted {
                    shape
                        .fill(LinearGradient(direction: .diagonalTopToBottom, nowPlayingViewModel.darkerAccentColor, nowPlayingViewModel.lighterAccentColor))
                        .overlay(
                            shape
                                .stroke(nowPlayingViewModel.lighterAccentColor, lineWidth: 2)
                                .blur(radius: 4)
                                .offset(x: -2, y: -2)
                                .mask(shape.fill(LinearGradient(direction: .diagonalTopToBottom, Color.clear, Color.black))))
                        .overlay(
                            shape
                                .stroke(nowPlayingViewModel.darkerAccentColor, lineWidth: 2)
                                .blur(radius: 8)
                                .offset(x: -2, y: -2)
                                .mask(shape.fill(LinearGradient(direction: .diagonalTopToBottom, Color.black, Color.clear))))
                        .shadow(color: Color.white.opacity(0.15), radius: 7, x: -2, y: -2)
                        .shadow(color: Color.black.opacity(0.5), radius: 7, x: 2, y: 2)
                        .blendMode(.overlay)
                    shape
                        .fill(LinearGradient(direction: .diagonalTopToBottom, nowPlayingViewModel.darkerAccentColor, nowPlayingViewModel.lighterAccentColor))
                        .overlay(shape.stroke(LinearGradient(direction: .diagonalTopToBottom, .blackGradient, .black), lineWidth: 2))
                } else {
                    shape
                        .fill(LinearGradient(direction: .diagonalTopToBottom, nowPlayingViewModel.lighterAccentColor, nowPlayingViewModel.darkerAccentColor))
                        .shadow(color: Color.white.opacity(0.15), radius: 10, x: -2, y: -2)
                        .shadow(color: Color.black.opacity(0.5), radius: 10, x: 2, y: 2)
                        .blendMode(.overlay)
                    shape
                        .fill(LinearGradient(direction: .diagonalTopToBottom, nowPlayingViewModel.lighterAccentColor, nowPlayingViewModel.darkerAccentColor))
                        .overlay(shape.stroke(LinearGradient(direction: .diagonalTopToBottom, .blackGradient, .black), lineWidth: 2))
                }
            } else {
                if isHighlighted {
                    shape
                        .fill(LinearGradient(direction: .diagonalTopToBottom, nowPlayingViewModel.darkerAccentColor, nowPlayingViewModel.lighterAccentColor))
                        .overlay(
                            shape
                                .stroke(nowPlayingViewModel.lighterAccentColor, lineWidth: 2)
                                .blur(radius: 4)
                                .offset(x: -2, y: -2)
                                .mask(shape.fill(LinearGradient(direction: .diagonalTopToBottom, Color.clear, Color.black))))
                        .overlay(
                            shape
                                .stroke(nowPlayingViewModel.darkerAccentColor, lineWidth: 2)
                                .blur(radius: 8)
                                .offset(x: -2, y: -2)
                                .mask(shape.fill(LinearGradient(direction: .diagonalTopToBottom, Color.black, Color.clear))))
                        .shadow(color: Color.black.opacity(0.5), radius: 7, x: 2, y: 2)
                        .shadow(color: Color.white.opacity(0.15), radius: 7, x: -2, y: -2)
                        .blendMode(.overlay)
                    shape
                        .fill(LinearGradient(direction: .diagonalTopToBottom, nowPlayingViewModel.darkerAccentColor, nowPlayingViewModel.lighterAccentColor))
                        .overlay(shape.stroke(LinearGradient(direction: .diagonalTopToBottom, .blackGradient, .black), lineWidth: 2))
                } else {
                    shape
                        .fill(LinearGradient(direction: .diagonalTopToBottom, nowPlayingViewModel.lighterAccentColor, nowPlayingViewModel.darkerAccentColor))
                        .shadow(color: Color.black.opacity(0.5), radius: 10, x: 2, y: 2)
                        .shadow(color: Color.white.opacity(0.15), radius: 10, x: -2, y: -2)
                        .blendMode(.overlay)
                    shape
                        .fill(LinearGradient(direction: .diagonalTopToBottom, nowPlayingViewModel.lighterAccentColor, nowPlayingViewModel.darkerAccentColor))
                        .overlay(shape.stroke(LinearGradient(direction: .diagonalTopToBottom, .blackGradient, .black), lineWidth: 2))
                }
            }
        }
        .frame(width: size, height: size)
        .transition(.move(edge: .bottom))

    }
}
