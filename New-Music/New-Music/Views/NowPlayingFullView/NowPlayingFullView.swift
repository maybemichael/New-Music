//
//  NowPlayingFullView.swift
//  New-Music
//
//  Created by Michael McGrath on 10/26/20.
//

import SwiftUI

struct NowPlayingFullView: View {
    @EnvironmentObject var nowPlayingViewModel: NowPlayingViewModel
    @GestureState private var dragState = DragState.inactive
    @State private var position: CGFloat = 0
    @State private var topAnchor: CGFloat = 0
    var frame: CGRect
    let musicController: MusicController
    var frameDelegate: FrameDelegate
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                GeometryReader { geometry in
                        Rectangle()
                            .foregroundColor(.clear)
                }
                .frame(width: UIScreen.main.bounds.width - 80, height: UIScreen.main.bounds.width - 80)
                    VStack(alignment: .center) {
                        Text(nowPlayingViewModel.artist)
//                        Text("Fall Out Boy")
                            .font(Font.system(.title3).weight(.medium))
                            .foregroundColor(nowPlayingViewModel.textColor2)
                            .multilineTextAlignment(.center)
                            .lineLimit(1)
                        Text(nowPlayingViewModel.songTitle)
//                        Text("Grand Theft Autumn")
                            .font(Font.system(.title3).weight(.medium))
                            .foregroundColor(textColorFor(isTooLight: nowPlayingViewModel.isTooLight))
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                        
                    }
                    .frame(minHeight: 85, alignment: .bottom)
                    
                    TrackProgressBarView(musicController: musicController)
                    HStack(spacing: 40) {
                        NeuTrackButton(size: UIScreen.main.bounds.width / 7, trackDirection: .trackBackward, musicController: musicController)
                            .frame(width: UIScreen.main.bounds.width / 7, height: UIScreen.main.bounds.width / 7, alignment: .center)
                        NeuPlayPauseButton(isPlaying: nowPlayingViewModel.isPlaying, musicController: musicController, labelPadding: 30, size: UIScreen.main.bounds.width / 4.7)
                            .frame(width: UIScreen.main.bounds.width / 4.7, height: UIScreen.main.bounds.width / 4.7, alignment: .center)
                        NeuTrackButton(size: UIScreen.main.bounds.width / 7, trackDirection: .trackForward, musicController: musicController)
                            .frame(width: UIScreen.main.bounds.width / 7, height: UIScreen.main.bounds.width / 7, alignment: .center)
                    }
                }
                .padding(.horizontal, 40)
                .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                .edgesIgnoringSafeArea(.all)

        }
        .frame(width: UIScreen.main.bounds.width)
        .background(nowPlayingBackground(for: nowPlayingViewModel.isMinimized).animation(nowPlayingViewModel.shouldAnimateColorChange ? Animation.linear(duration: 0.55) : Animation.easeOut(duration: 0.05)))
        .edgesIgnoringSafeArea(.all)
        .coordinateSpace(name: "FullNowPlayingView")
    }
    
    
    
    private func getTopInset() -> CGFloat {
        guard let topInset = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first?.safeAreaInsets.top else { return 30 }
        return topInset + 10
    }
    
    private func setOffset() -> CGFloat {
        return self.position + self.dragState.translation.height
    }
    
    private func getCenterX() -> CGFloat {
        let imageWidth = UIScreen.main.bounds.width - 80
        let halfWidth: CGFloat = imageWidth / 2
        let margin: CGFloat = 40
        return margin + halfWidth
    }
    private func getCenterY() -> CGFloat {
        let imageWidth = UIScreen.main.bounds.width - 80
        let halfHeight: CGFloat = imageWidth / 2
        let topMargin = UIScreen.main.bounds.height / 6
        return topMargin + halfHeight
    }
    
    private func opacity(for whiteLevel: CGFloat) -> Double {
        switch whiteLevel {
        case 0...0.2:
            return 0.8
        case 0.21...0.3:
            return 0.65
        case 0.31...0.5:
            return 0.6
        case 0.51...0.7:
            return 0.5
        case 0.71...0.87:
            return 0.35
        case 0.88...1:
            return 0.3
        default:
            return 1.0
        }
    }
    
    private func textColorFor(isTooLight: Bool) -> Color {
        return isTooLight ? Color.white : Color.white
    }
    
    private func nowPlayingBackground(for isMinimized: Bool) -> Color {
        if isMinimized {
            return Color.nowPlayingBG.opacity(0.8)
        } else {
            return backgroundColorFor(isTooLight: nowPlayingViewModel.isTooLight).opacity(opacity(for: nowPlayingViewModel.whiteLevel))
        }
    }
    
    private func backgroundColorFor(isTooLight: Bool) -> Color {
        return isTooLight ? nowPlayingViewModel.darkerAccentColor.opacity(opacity(for: nowPlayingViewModel.whiteLevel)) : nowPlayingViewModel.lighterAccentColor.opacity(opacity(for: nowPlayingViewModel.whiteLevel))
    }
}

struct NowPlayingFullView_Previews: PreviewProvider {
    static var previews: some View {
        let musicController = MusicController()
        NowPlayingFullView(frame: CGRect(x: 40, y: UIScreen.main.bounds.height / 6, width: UIScreen.main.bounds.width - 80, height: UIScreen.main.bounds.width - 80), musicController: musicController, frameDelegate: NowPlayingFullViewController()).environmentObject(musicController.nowPlayingViewModel)
    }
}

struct Background: ViewModifier {
    
    @EnvironmentObject var nowPlayingViewModel: NowPlayingViewModel
    
    func body(content: Content) -> some View {
        content
            .background(nowPlayingBackground(for: nowPlayingViewModel.shouldAnimateColorChange).animation(nowPlayingViewModel.isFull ? Animation.linear(duration: 0.5) : Animation.linear(duration: 0.05)))
            
    }
    
    
    private func nowPlayingBackground(for animateColor: Bool) -> Color {
        if animateColor {
            return backgroundColorFor(isTooLight: nowPlayingViewModel.isTooLight).opacity(opacity(for: nowPlayingViewModel.whiteLevel))
        } else {
            return backgroundColorFor(isTooLight: nowPlayingViewModel.isTooLight).opacity(opacity(for: nowPlayingViewModel.whiteLevel))
//            return Color.nowPlayingBG
        }
    }
    
    private func opacity(for whiteLevel: CGFloat) -> Double {
        switch whiteLevel {
        case 0...0.2:
            return 0.8
        case 0.21...0.3:
            return 0.65
        case 0.31...0.5:
            return 0.6
        case 0.51...0.7:
            return 0.5
        case 0.71...0.87:
            return 0.35
        case 0.88...1:
            return 0.3
        default:
            return 1.0
        }
    }
    
    private func backgroundColorFor(isTooLight: Bool) -> Color {
        return isTooLight ? nowPlayingViewModel.darkerAccentColor.opacity(opacity(for: nowPlayingViewModel.whiteLevel)) : nowPlayingViewModel.lighterAccentColor.opacity(opacity(for: nowPlayingViewModel.whiteLevel))
    }
}
