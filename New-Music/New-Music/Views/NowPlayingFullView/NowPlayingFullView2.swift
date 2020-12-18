//
//  NowPlayingFullView2.swift
//  New-Music
//
//  Created by Michael McGrath on 12/17/20.
//

import SwiftUI

struct NowPlayingFullView2: View {
    
    @EnvironmentObject var nowPlayingViewModel: NowPlayingViewModel
    let musicController: MusicController
    var frameDelegate: FrameDelegate
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: UIScreen.main.bounds.width - 80, height: UIScreen.main.bounds.width - 80, alignment: .bottom)
                }
                .frame(width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height / 2) + 20, alignment: .bottom)
                VStack(spacing: 20) {
                    VStack(alignment: .center) {
                        Text(nowPlayingViewModel.artist)
//                        Text("Taking Back Sunday")
                            .font(Font.system(.title3).weight(.medium))
                            .foregroundColor(nowPlayingViewModel.textColor2)
                            .multilineTextAlignment(.center)
                            .lineLimit(1)
                        Text(nowPlayingViewModel.songTitle)
//                        Text("Cute Without the 'E' (Cut From the Team) [Remastered]")
                            .font(Font.system(.title3).weight(.medium))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .minimumScaleFactor(0.5)
                        
                    }
                    .padding(.horizontal, 40)
                    .padding(.top, 30)
                    .frame(height: UIScreen.main.bounds.width / 4.5)
                    TrackProgressBarView(musicController: musicController)
                }
                HStack(spacing: 40) {
                    NeuTrackButton(size: UIScreen.main.bounds.width / 7, trackDirection: .trackBackward, musicController: musicController)
                        .frame(width: UIScreen.main.bounds.width / 7, height: UIScreen.main.bounds.width / 7, alignment: .center)
                    NeuPlayPauseButton(isPlaying: nowPlayingViewModel.isPlaying, musicController: musicController, labelPadding: 30, size: UIScreen.main.bounds.width / 4.7)
                        .frame(width: UIScreen.main.bounds.width / 4.7, height: UIScreen.main.bounds.width / 4.7, alignment: .center)
                    NeuTrackButton(size: UIScreen.main.bounds.width / 7, trackDirection: .trackForward, musicController: musicController)
                        .frame(width: UIScreen.main.bounds.width / 7, height: UIScreen.main.bounds.width / 7, alignment: .center)
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .top)
        .background(nowPlayingBackground(for: nowPlayingViewModel.isMinimized).animation(nowPlayingViewModel.shouldAnimateColorChange ? Animation.linear(duration: 0.55) : Animation.easeOut(duration: 0.05)))
        .edgesIgnoringSafeArea(.all)
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
}

struct NowPlayingFullView2_Previews: PreviewProvider {
    static var previews: some View {
        let musicController = MusicController()
        NowPlayingFullView2(musicController: musicController, frameDelegate: NowPlayingFullViewController()).environmentObject(musicController.nowPlayingViewModel)
    }
}
