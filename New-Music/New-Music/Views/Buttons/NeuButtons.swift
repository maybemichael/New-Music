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
    var size: CGFloat
    
    var body: some View {
        Toggle(isOn: $isPlaying) {
            Image(systemName: songViewModel.isPlaying ? "pause": "play.fill")
                .font(Font.system(size: size / 3, weight: .black, design: .default))
                .padding()
                .foregroundColor(Color(imageTint(isTooLight: songViewModel.isTooLight)))
//                .font(Font.system(.callout).weight(.black))
                
        }
        .toggleStyle(ToggleButtonStyle(musicController: musicController, size: size))
    }
    
    private func imageTint(isTooLight: Bool) -> UIColor {
        isTooLight ? UIColor.black : UIColor.white
    }
    
    private func gradient(for state: Bool) -> LinearGradient {
        state ? LinearGradient(direction: .diagonalTopToBottom, songViewModel.darkerAccentColor, songViewModel.lighterAccentColor) : LinearGradient(direction: .diagonalTopToBottom, songViewModel.lighterAccentColor, songViewModel.darkerAccentColor)
    }
}

struct ToggleButtonStyle: ToggleStyle {
    @EnvironmentObject var nowPlayingViewModel: NowPlayingViewModel
    var musicController: MusicController
    var size: CGFloat
    
    func makeBody(configuration: Self.Configuration) -> some View {
        Button(action: {
            nowPlayingViewModel.isPlaying.toggle()
            configuration.isOn = nowPlayingViewModel.isPlaying ? true : false
            configuration.isOn ? musicController.play() : musicController.pause()
        }) {
            configuration.label
                .contentShape(Circle())
                .background(NeuToggleBackground(shape: Circle(), size: size))
        }
    }
    private func imageTint(isTooLight: Bool) -> UIColor {
        isTooLight ? UIColor.black : UIColor.white
    }
    
    private func gradient(for state: Bool) -> LinearGradient {
        state ? LinearGradient(direction: .diagonalTopToBottom, nowPlayingViewModel.darkerAccentColor, nowPlayingViewModel.lighterAccentColor) : LinearGradient(direction: .diagonalTopToBottom, nowPlayingViewModel.lighterAccentColor, nowPlayingViewModel.darkerAccentColor)
    }
}

struct NeuToggleBackground<S: Shape>: View {
    @EnvironmentObject var nowPlayingViewModel: NowPlayingViewModel
    var shape: S
    var size: CGFloat
    
    var body: some View {
        ZStack {
            Color.clear
                .edgesIgnoringSafeArea(.all)
            if nowPlayingViewModel.whiteLevel < 0.4 {
                shape
                    .fill(gradient(for: nowPlayingViewModel.isPlaying))
                    .shadow(color: Color.black.opacity(0.7), radius: 10, x: 5, y: 5)
                    .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                    .blendMode(.overlay)
                shape
                    .fill(gradient(for: nowPlayingViewModel.isPlaying))
                    .overlay(shape.stroke(LinearGradient(direction: .diagonalTopToBottom, .black, .black), lineWidth: 2))
            } else {
                shape
                    .fill(gradient(for: nowPlayingViewModel.isPlaying))
                    .shadow(color: Color.black.opacity(0.7), radius: 10, x: 5, y: 5)
                    .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                    .blendMode(.overlay)
                shape
                    .fill(gradient(for: nowPlayingViewModel.isPlaying))
                    .overlay(shape.stroke(LinearGradient(direction: .diagonalTopToBottom, .black, .black), lineWidth: 2))
            }
        }
        .frame(width: size, height: size)
    }
    private func gradient(for state: Bool) -> LinearGradient {
        state ? LinearGradient(direction: .diagonalTopToBottom, nowPlayingViewModel.darkerAccentColor, nowPlayingViewModel.lighterAccentColor) : LinearGradient(direction: .diagonalTopToBottom, nowPlayingViewModel.lighterAccentColor, nowPlayingViewModel.darkerAccentColor)
    }
    
    private func darkShadowOpacity(for whiteLevel: CGFloat) -> Double {
        switch nowPlayingViewModel.whiteLevel {
        case 0...0.3:
            return 0.6
        case 0.31...0.7:
            return 0.65
        case 0.71...1:
            return 0.8
        default:
            return 0.7
        }
    }
    
    private func lightShadowOpacity(for whiteLevel: CGFloat) -> Double {
        switch nowPlayingViewModel.whiteLevel {
        case 0...0.1:
            return 0.4
        case 0.11...0.7:
            return 0.5
        case 0.71...1:
            return 0.6
        default:
            return 0.2
        }
    }
}

struct NeuSwiftUIButton: View {
    @EnvironmentObject var songViewModel: NowPlayingViewModel
    var size: CGFloat
    var buttonType: NeuButtonType
    var musicController: MusicController
    
    var body: some View {
        Button(action: {
            actionForButtonType()
//            buttonType == .trackForward ? musicController.nextTrack() : musicController.previousTrack()
        }) {
            Image(systemName: imageForButtonType())
                .font(Font.system(size: size / 4, weight: .semibold, design: .default))
                .padding()
                .foregroundColor(imageTint(isTooLight: songViewModel.isTooLight))
//                .font(Font.system(.callout).weight(.black))
        }
        .buttonStyle(NeuButtonStyle(size: size))
//        .frame(width: size, height: size)
    }
    private func imageTint(isTooLight: Bool) -> Color {
        isTooLight ? Color.black : Color.white
    }
    
    private func imageForButtonType() -> String {
        switch buttonType {
        case .trackForward:
            return "forward.fill"
        case .trackBackward:
            return "backward.fill"
        case .shuffle:
            return "shuffle"
        case .menu:
            return "line.horizontal.3"
        case .repeatPlayback:
            return "repeat"
        }
    }
    
    private func actionForButtonType() {
        switch buttonType {
        case .trackForward:
            musicController.nextTrack()
        case .trackBackward:
            musicController.previousTrack()
        case .shuffle:
            musicController.shufflePlaylist()
        case .repeatPlayback:
            if musicController.musicPlayer.repeatMode == .none {
                musicController.musicPlayer.repeatMode = .one
            } else {
                musicController.musicPlayer.repeatMode = .none
            }
        default:
            break
        }
    }
}

struct NeuButtonStyle: ButtonStyle {
    @EnvironmentObject var nowPlayingViewModel: NowPlayingViewModel
    var size: CGFloat
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
//            .padding(size / 3)
            .contentShape(Circle())
            .background(NeuButtonBackground(isHighlighted: configuration.isPressed, shape: Circle(), size: size))
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
    }
}

struct NeuButtonBackground<S: Shape>: View {
    @EnvironmentObject var nowPlayingViewModel: NowPlayingViewModel
    var isHighlighted: Bool
    var shape: S
    var size: CGFloat
    
    var body: some View {
        ZStack {
            Color.clear
                .edgesIgnoringSafeArea(.all)
            if nowPlayingViewModel.whiteLevel < 0.4 {
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
                        .shadow(color: Color.black.opacity(0.7), radius: 10, x: 5, y: 5)
                        .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                        .blendMode(.overlay)
                    shape
                        .fill(LinearGradient(direction: .diagonalTopToBottom, nowPlayingViewModel.darkerAccentColor, nowPlayingViewModel.lighterAccentColor))
                        .overlay(shape.stroke(LinearGradient(direction: .diagonalTopToBottom, .black, .black), lineWidth: 2))
                } else {
                    shape
                        .fill(LinearGradient(direction: .diagonalTopToBottom, nowPlayingViewModel.lighterAccentColor, nowPlayingViewModel.darkerAccentColor))
                        .shadow(color: Color.black.opacity(0.7), radius: 10, x: 5, y: 5)
                        .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                        .blendMode(.overlay)
                    shape
                        .fill(LinearGradient(direction: .diagonalTopToBottom, nowPlayingViewModel.lighterAccentColor, nowPlayingViewModel.darkerAccentColor))
                        .overlay(shape.stroke(LinearGradient(direction: .diagonalTopToBottom, .black, .black), lineWidth: 2))
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
                        .shadow(color: Color.black.opacity(0.7), radius: 10, x: 5, y: 5)
                        .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                        .blendMode(.overlay)
                    shape
                        .fill(LinearGradient(direction: .diagonalTopToBottom, nowPlayingViewModel.darkerAccentColor, nowPlayingViewModel.lighterAccentColor))
                        .overlay(shape.stroke(LinearGradient(direction: .diagonalTopToBottom, .sysGraySix, .black), lineWidth: 2))
                } else {
                    shape
                        .fill(LinearGradient(direction: .diagonalTopToBottom, nowPlayingViewModel.lighterAccentColor, nowPlayingViewModel.darkerAccentColor))
                        .shadow(color: Color.black.opacity(0.7), radius: 10, x: 5, y: 5)
                        .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                        .blendMode(.overlay)
                    shape
                        .fill(LinearGradient(direction: .diagonalTopToBottom, nowPlayingViewModel.lighterAccentColor, nowPlayingViewModel.darkerAccentColor))
                        .overlay(shape.stroke(LinearGradient(direction: .diagonalTopToBottom, .sysGraySix, .black), lineWidth: 2))
                }
            }
        }
        .frame(width: size, height: size)
    }
    
    private func gradient(for state: Bool) -> LinearGradient {
        state ? LinearGradient(direction: .diagonalTopToBottom, nowPlayingViewModel.lighterAccentColor, nowPlayingViewModel.darkerAccentColor) : LinearGradient(direction: .diagonalTopToBottom, nowPlayingViewModel.darkerAccentColor, nowPlayingViewModel.lighterAccentColor)
    }
    
    private func darkShadowOpacity(for whiteLevel: CGFloat) -> Double {
        switch nowPlayingViewModel.whiteLevel {
        case 0...0.3:
            return 0.6
        case 0.31...0.7:
            return 0.65
        case 0.71...1:
            return 0.8
        default:
            return 0.7
        }
    }
    
    private func lightShadowOpacity(for whiteLevel: CGFloat) -> Double {
        switch nowPlayingViewModel.whiteLevel {
        case 0...0.1:
            return 0.5
        case 0.11...0.7:
            return 0.5
        case 0.71...1:
            return 0.6
        default:
            return 0.2
        }
    }
}

struct PlayPauseButton: View {
    @EnvironmentObject var nowPlayingViewModel: NowPlayingViewModel
    @State var isPlaying: Bool
    var musicController: MusicController
    var labelPadding: CGFloat
    var size: CGFloat
    let namespace: Namespace.ID
    
    var body: some View {
        Toggle(isOn: $isPlaying) {
            Image(systemName: nowPlayingViewModel.isPlaying ? "pause": "play.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color(imageTint(isTooLight: nowPlayingViewModel.isTooLight)))
                .font(Font.system(.callout).weight(.black))
                
        }
        .toggleStyle(ToggleButtonStyle(musicController: musicController, size: size))
    }
    
    private func imageTint(isTooLight: Bool) -> UIColor {
        isTooLight ? UIColor.black : UIColor.white
    }
    
    private func gradient(for state: Bool) -> LinearGradient {
        state ? LinearGradient(direction: .diagonalTopToBottom, nowPlayingViewModel.darkerAccentColor, nowPlayingViewModel.lighterAccentColor) : LinearGradient(direction: .diagonalTopToBottom, nowPlayingViewModel.lighterAccentColor, nowPlayingViewModel.darkerAccentColor)
    }
}

struct TrackButton: View {
    @EnvironmentObject var nowPlayingViewModel: NowPlayingViewModel
    var size: CGFloat
    var trackDirection: NeuButtonType
    var musicController: MusicController
//    var isHighlighted: Bool
    
    var body: some View {
        Button(action: {
            trackDirection == .trackForward ? musicController.nextTrack() : musicController.previousTrack()
        }) {
            Image(systemName: getImageName())
                .foregroundColor(imageTint(isTooLight: nowPlayingViewModel.isTooLight))
                .aspectRatio(contentMode: .fit)
                .font(Font.system(.headline).weight(.semibold))
        }
        .buttonStyle(NeuButton(size: size))
        .transition(.move(edge: .bottom))
        .animation(.easeOut(duration: 0.3))
    }
    
    private func imageTint(isTooLight: Bool) -> Color {
        isTooLight ? Color.black : Color.white
    }
    
    private func getImageName() -> String {
        trackDirection == .trackForward ? "forward.fill" : "backward.fill"
    }
}

struct BarPlayPauseButton: View {
    @EnvironmentObject var songViewModel: NowPlayingViewModel
    @State var isPlaying: Bool
    var musicController: MusicController
//    var labelPadding: CGFloat
    var size: CGFloat
    
    var body: some View {
        Toggle(isOn: $isPlaying) {
            Image(systemName: songViewModel.isPlaying ? "pause": "play.fill")
                .font(Font.system(size: size / 3, weight: .black, design: .default))
                .padding()
                .foregroundColor(Color(imageTint(isTooLight: songViewModel.isTooLight)))
                
        }
        .toggleStyle(BarToggleButtonStyle(musicController: musicController, size: size, labelPadding: size / 3))
    }
    
    func imageTint(isTooLight: Bool) -> UIColor {
        isTooLight ? UIColor.black : UIColor.white
    }
    
    private func gradient(for state: Bool) -> LinearGradient {
        state ? LinearGradient(direction: .diagonalTopToBottom, songViewModel.darkerAccentColor, songViewModel.lighterAccentColor) : LinearGradient(direction: .diagonalTopToBottom, songViewModel.lighterAccentColor, songViewModel.darkerAccentColor)
    }
}

struct BarTrackButton: View {
    @EnvironmentObject var songViewModel: NowPlayingViewModel
    var size: CGFloat
    var buttonType: NeuButtonType
    var musicController: MusicController
    
    var body: some View {
        Button(action: {
            buttonType == .trackForward ? musicController.nextTrack() : musicController.previousTrack()
        }) {
            Image(systemName: imageForButtonType())
                .font(Font.system(size: size / 3.5, weight: .semibold, design: .default))
                .padding()
                .foregroundColor(imageTint(isTooLight: songViewModel.isTooLight))
        }
        .buttonStyle(BarTrackButtonStyle(size: size))
    }
    private func imageTint(isTooLight: Bool) -> Color {
        isTooLight ? Color.black : Color.white
    }
    
    private func imageForButtonType() -> String {
        switch buttonType {
        case .trackForward:
            return "forward.fill"
        case .trackBackward:
            return "backward.fill"
        case .shuffle:
            return "shuffle"
        case .menu:
            return "line.horizontal.3"
        case .repeatPlayback:
            return "repeat"
        }
    }
    
    private func actionForButtonType() {
        switch buttonType {
        case .trackForward:
            musicController.nextTrack()
        case .trackBackward:
            musicController.previousTrack()
        case .shuffle:
            if musicController.musicPlayer.shuffleMode == .off {
                musicController.musicPlayer.shuffleMode = .songs
            } else {
                musicController.musicPlayer.shuffleMode = .off
            }
        case .repeatPlayback:
            if musicController.musicPlayer.repeatMode == .none {
                musicController.musicPlayer.repeatMode = .one
            } else {
                musicController.musicPlayer.repeatMode = .none
            }
        default:
            break
        }
    }
}
