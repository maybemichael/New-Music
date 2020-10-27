//
//  NeuButtons.swift
//  New-Music
//
//  Created by Michael McGrath on 10/26/20.
//

import SwiftUI

struct NeuPlayPauseButton: View {
    @EnvironmentObject var songViewModel: NowPlayingViewModel
    @State var isPlaying: Bool
    var musicController: MusicController
    var labelPadding: CGFloat
    var size: CGFloat
    
    var body: some View {
        Toggle(isOn: $isPlaying) {
            Image(systemName: songViewModel.isPlaying ? "pause": "play.fill")
                .resizable()
                .foregroundColor(Color(imageTint(isTooLight: songViewModel.isTooLight)))
                .aspectRatio(contentMode: .fit)
                .font(Font.system(.callout).weight(.black))
                
        }
        .toggleStyle(ToggleButtonStyle(musicController: musicController, size: size, labelPadding: labelPadding))
    }
    
    func imageTint(isTooLight: Bool) -> UIColor {
        isTooLight ? UIColor.black : UIColor.white
    }
    
    private func gradient(for state: Bool) -> LinearGradient {
        state ? LinearGradient(direction: .diagonalTopToBottom, songViewModel.darkerAccentColor, songViewModel.lighterAccentColor) : LinearGradient(direction: .diagonalTopToBottom, songViewModel.lighterAccentColor, songViewModel.darkerAccentColor)
    }
}

struct ToggleButtonStyle: ToggleStyle {
    @EnvironmentObject var songViewModel: NowPlayingViewModel
    var musicController: MusicController
    var size: CGFloat
    var labelPadding: CGFloat
    
    func makeBody(configuration: Self.Configuration) -> some View {
        Button(action: {
            songViewModel.isPlaying.toggle()
            configuration.isOn = songViewModel.isPlaying ? true : false
            configuration.isOn ? musicController.play() : musicController.pause()
        }) {
            configuration.label
                .padding(labelPadding)
                .contentShape(Circle())
                .background(NeuToggleBackground(shape: Circle(), size: size))
        }
    }
}

struct NeuToggleBackground<S: Shape>: View {
    @EnvironmentObject var songViewModel: NowPlayingViewModel
    var shape: S
//    var lighterColor: Color
//    var darkerColor: Color
    var size: CGFloat
    
    var body: some View {
        ZStack {
            if songViewModel.whiteLevel < 0.3 {
                shape
                    .fill(gradient(for: songViewModel.isPlaying))
                    .shadow(color: Color.white.opacity(0.5), radius: 10, x: -5, y: -5)
                    .shadow(color: Color.black.opacity(0.5), radius: 10, x: 5, y: 5)
                    .blendMode(.overlay)
                shape
                    .fill(gradient(for: songViewModel.isPlaying))
                    .overlay(shape.stroke(LinearGradient(direction: .diagonalTopToBottom, .blackGradient, .black), lineWidth: 2))
            } else {
                shape
                    .fill(gradient(for: songViewModel.isPlaying))
                    .shadow(color: Color.white.opacity(0.9), radius: 10, x: -5, y: -5)
                    .shadow(color: Color.black.opacity(0.5), radius: 10, x: 5, y: 5)
                    .blendMode(.overlay)
                shape
                    .fill(gradient(for: songViewModel.isPlaying))
                    .overlay(shape.stroke(LinearGradient(direction: .diagonalTopToBottom, .blackGradient, .black), lineWidth: 2))
            }
        }
        .frame(width: size, height: size)
    }
    private func gradient(for state: Bool) -> LinearGradient {
        state ? LinearGradient(direction: .diagonalTopToBottom, songViewModel.darkerAccentColor, songViewModel.lighterAccentColor) : LinearGradient(direction: .diagonalTopToBottom, songViewModel.lighterAccentColor, songViewModel.darkerAccentColor)
    }
}

struct TrackButton: View {
    @EnvironmentObject var songViewModel: NowPlayingViewModel
    var size: CGFloat
    var trackDirection: TrackDirection
    var musicController: MusicController
    
    var body: some View {
        Button(action: {
            trackDirection == .trackForward ? musicController.nextTrack() : musicController.previousTrack()
        }) {
            Image(systemName: getImageName())
                .foregroundColor(imageTint(isTooLight: songViewModel.isTooLight))
                .aspectRatio(contentMode: .fit)
                .font(Font.system(.headline).weight(.semibold))
        }
        .buttonStyle(NeuButtonStyle(size: size))
        .frame(width: size, height: size)
    }
    private func imageTint(isTooLight: Bool) -> Color {
        isTooLight ? Color.black : Color.white
    }
    
    private func getImageName() -> String {
        trackDirection == .trackForward ? "forward.fill" : "backward.fill"
    }
}

struct NeuButtonStyle: ButtonStyle {
    @EnvironmentObject var songViewModel: NowPlayingViewModel
    var size: CGFloat
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(30)
            .contentShape(Circle())
            .background(NeuButtonBackground(isHighlighted: configuration.isPressed, shape: Circle(), size: size))
    }
}

struct NeuButtonBackground<S: Shape>: View {
    @EnvironmentObject var songViewModel: NowPlayingViewModel
    var isHighlighted: Bool
    var shape: S
    var size: CGFloat
    
    var body: some View {
        ZStack {
            if songViewModel.whiteLevel < 0.3 {
                if isHighlighted {
                    shape
                        .fill(LinearGradient(direction: .diagonalTopToBottom, songViewModel.darkerAccentColor, songViewModel.lighterAccentColor))
                        .overlay(
                            shape
                                .stroke(songViewModel.lighterAccentColor, lineWidth: 2)
                                .blur(radius: 4)
                                .offset(x: -2, y: -2)
                                .mask(shape.fill(LinearGradient(direction: .diagonalTopToBottom, Color.clear, Color.black))))
                        .overlay(
                            shape
                                .stroke(songViewModel.darkerAccentColor, lineWidth: 2)
                                .blur(radius: 8)
                                .offset(x: -2, y: -2)
                                .mask(shape.fill(LinearGradient(direction: .diagonalTopToBottom, Color.black, Color.clear))))
                        .shadow(color: Color.black.opacity(0.5), radius: 7, x: 5, y: 5)
                        .shadow(color: Color.white.opacity(0.5), radius: 7, x: -5, y: -5)
                        .blendMode(.overlay)
                    shape
                        .fill(LinearGradient(direction: .diagonalTopToBottom, songViewModel.darkerAccentColor, songViewModel.lighterAccentColor))
                        .overlay(shape.stroke(LinearGradient(direction: .diagonalTopToBottom, .blackGradient, .black), lineWidth: 2))
                } else {
                    shape
                        .fill(LinearGradient(direction: .diagonalTopToBottom, songViewModel.lighterAccentColor, songViewModel.darkerAccentColor))
                        .shadow(color: Color.black.opacity(0.5), radius: 10, x: 5, y: 5)
                        .shadow(color: Color.white.opacity(0.5), radius: 10, x: -5, y: -5)
                        .blendMode(.overlay)
                    shape
                        .fill(LinearGradient(direction: .diagonalTopToBottom, songViewModel.lighterAccentColor, songViewModel.darkerAccentColor))
                        .overlay(shape.stroke(LinearGradient(direction: .diagonalTopToBottom, .blackGradient, .black), lineWidth: 2))
                }
            }
        else {
                if isHighlighted {
                    shape
                        .fill(LinearGradient(direction: .diagonalTopToBottom, songViewModel.darkerAccentColor, songViewModel.lighterAccentColor))
                        .overlay(
                            shape
                                .stroke(songViewModel.lighterAccentColor, lineWidth: 2)
                                .blur(radius: 4)
                                .offset(x: -2, y: -2)
                                .mask(shape.fill(LinearGradient(direction: .diagonalTopToBottom, Color.clear, Color.black))))
                        .overlay(
                            shape
                                .stroke(songViewModel.darkerAccentColor, lineWidth: 2)
                                .blur(radius: 8)
                                .offset(x: -2, y: -2)
                                .mask(shape.fill(LinearGradient(direction: .diagonalTopToBottom, Color.black, Color.clear))))
                        .shadow(color: Color.black.opacity(0.5), radius: 7, x: 5, y: 5)
                        .shadow(color: Color.white.opacity(0.5), radius: 7, x: -5, y: -5)
                        .blendMode(.overlay)
                    shape
                        .fill(LinearGradient(direction: .diagonalTopToBottom, songViewModel.darkerAccentColor, songViewModel.lighterAccentColor))
                        .overlay(shape.stroke(LinearGradient(direction: .diagonalTopToBottom, .blackGradient, .black), lineWidth: 2))
                } else {
                    shape
                        .fill(LinearGradient(direction: .diagonalTopToBottom, songViewModel.lighterAccentColor, songViewModel.darkerAccentColor))
                        .shadow(color: Color.black.opacity(0.5), radius: 10, x: 5, y: 5)
                        .shadow(color: Color.white.opacity(0.5), radius: 10, x: -5, y: -5)
                        .blendMode(.overlay)
                    shape
                        .fill(LinearGradient(direction: .diagonalTopToBottom, songViewModel.lighterAccentColor, songViewModel.darkerAccentColor))
                        .overlay(shape.stroke(LinearGradient(direction: .diagonalTopToBottom, .blackGradient, .black), lineWidth: 2))
                }
            }
        }
        .frame(width: size, height: size)
    }
    
    private func gradient(for state: Bool) -> LinearGradient {
        state ? LinearGradient(direction: .diagonalTopToBottom, songViewModel.lighterAccentColor, songViewModel.darkerAccentColor) : LinearGradient(direction: .diagonalTopToBottom, songViewModel.darkerAccentColor, songViewModel.lighterAccentColor)
    }
}
