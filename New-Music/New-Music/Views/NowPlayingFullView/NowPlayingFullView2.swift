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
        if UIDevice.current.userInterfaceIdiom == .pad {
            GeometryReader { geo in
                VStack {
                    ZStack {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: UIScreen.main.bounds.width / 1.35, height: UIScreen.main.bounds.width / 1.35, alignment: .bottom)
                        .frame(alignment: .bottom)
                    }
                    .frame(width: UIScreen.main.bounds.width, height: (geo.size.height / 2) + (UIScreen.main.bounds.width / 7), alignment: .bottom)
                    VStack(spacing: 20) {
                        VStack(alignment: .center) {
//                            Text(nowPlayingViewModel.artist)
                            Text("Taking Back Sunday")
                                .font(Font.system(.title3).weight(.medium))
                                .foregroundColor(nowPlayingViewModel.textColor2)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                                .minimumScaleFactor(0.5)
//                            Text(nowPlayingViewModel.songTitle)
                            Text("Cute Without the 'E' (Cut From the Team) [Remastered]")
                                .font(Font.system(.title3).weight(.medium))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                                .minimumScaleFactor(0.5)
                            
                        }
                        .frame(height: UIScreen.main.bounds.width / 8)
                        TrackProgressView(musicController: musicController, barHeight: 10, indicatorHeight: 16, barWidth: UIScreen.main.bounds.width / 1.4)
                        HStack(spacing: 40) {
                            NeuSwiftUIButton(size: UIScreen.main.bounds.width / 14,  buttonType: .shuffle, musicController: musicController)
                            NeuSwiftUIButton(size: UIScreen.main.bounds.width / 12, buttonType: .trackBackward, musicController: musicController)
                            NeuPlayPauseButton(isPlaying: nowPlayingViewModel.isPlaying, musicController: musicController, size: UIScreen.main.bounds.width / 8)
                                .frame(width: UIScreen.main.bounds.width / 8, height: UIScreen.main.bounds.width / 8, alignment: .center)
                            NeuSwiftUIButton(size: UIScreen.main.bounds.width / 12, buttonType: .trackForward, musicController: musicController)
                            NeuSwiftUIButton(size: UIScreen.main.bounds.width / 14, buttonType: .repeatPlayback, musicController: musicController)
                        }
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .top)
            .background(nowPlayingBackground(for: nowPlayingViewModel.isMinimized).animation(nowPlayingViewModel.shouldAnimateColorChange ? Animation.linear(duration: 0.55) : Animation.easeOut(duration: 0.05)))
            .edgesIgnoringSafeArea(.all)
        } else if UIDevice.current.userInterfaceIdiom == .phone {
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
//                            Text("Taking Back Sunday")
                                .font(Font.system(.title3).weight(.medium))
                                .foregroundColor(nowPlayingViewModel.textColor2)
                                .multilineTextAlignment(.center)
                                .lineLimit(1)
                            Text(nowPlayingViewModel.songTitle)
//                            Text("Cute Without the 'E' (Cut From the Team) [Remastered]")
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
                    HStack {
                        Spacer()
                        NeuSwiftUIButton(size: UIScreen.main.bounds.width / 7, buttonType: .trackBackward, musicController: musicController)
                            .frame(width: UIScreen.main.bounds.width / 7, height: UIScreen.main.bounds.width / 7, alignment: .center)
                        Spacer()
                        NeuPlayPauseButton(isPlaying: nowPlayingViewModel.isPlaying, musicController: musicController, size: UIScreen.main.bounds.width / 4.7)
                            .frame(width: UIScreen.main.bounds.width / 4.7, height: UIScreen.main.bounds.width / 4.7, alignment: .center)
                        Spacer()
                        NeuSwiftUIButton(size: UIScreen.main.bounds.width / 7, buttonType: .trackForward, musicController: musicController)
                            .frame(width: UIScreen.main.bounds.width / 7, height: UIScreen.main.bounds.width / 7, alignment: .center)
                        Spacer()
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .top)
            .background(nowPlayingBackground(for: nowPlayingViewModel.isMinimized).animation(nowPlayingViewModel.shouldAnimateColorChange ? Animation.linear(duration: 0.55) : Animation.easeOut(duration: 0.05)))
            .edgesIgnoringSafeArea(.all)
        }
    }
    
    private func nowPlayingBackground(for isMinimized: Bool) -> Color {
        if isMinimized {
            return Color.nowPlayingBG.opacity(0.6)
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
