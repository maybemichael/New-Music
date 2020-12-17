//
//  NowPlayingViewFull.swift
//  New-Music
//
//  Created by Michael McGrath on 12/16/20.
//

import SwiftUI

struct NowPlayingViewFull2: View {
    @EnvironmentObject var nowPlayingViewModel: NowPlayingViewModel
    var musicController: MusicController
    var frameDelegate: FrameDelegate
    
    var body: some View {
//        GeometryReader { geo in
        VStack {
            VStack(spacing: 12) {
                    GeometryReader { geometry in
                        Rectangle()
                            .foregroundColor(.clear)
//                            .onChange(of: nowPlayingViewModel.getFrame, perform: { value in
//                                let x = geometry.frame(in: .global).origin.x - (geometry.frame(in: .global).size.width * 0.015)
//                                let y = geometry.frame(in: .global).origin.y - (geometry.frame(in: .global).size.width * 0.015)
//                                let width = geometry.frame(in: .global).size.width + (geometry.size.width * 0.03)
//                                let height = geometry.frame(in: .global).size.height + (geometry.size.height * 0.03)
//                                let frame = CGRect(x: x, y: y, width: width, height: height)
//                                frameDelegate.getFrame(frame: frame)
//                                print("Frame for Album Artwork on Change in global: \(frame)")
//                            })
                    }
                    .frame(width: UIScreen.main.bounds.width - 80, height: UIScreen.main.bounds.width - 80, alignment: .bottom)
//                VStack {
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
//                    .padding(.vertical, 20)
                    .frame(height: 80, alignment: .center)
                    
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
//                }
            }
        .padding(.horizontal, 40)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
            .background(nowPlayingBackground(for: nowPlayingViewModel.isMinimized).animation(nowPlayingViewModel.shouldAnimateColorChange ? Animation.linear(duration: 0.55) : Animation.easeOut(duration: 0.05)))
            .edgesIgnoringSafeArea(.all)
//        }
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

struct NowPlayingViewFull2_Previews: PreviewProvider {
    static var previews: some View {
        let musicController = MusicController()
        NowPlayingViewFull2(musicController: musicController, frameDelegate: NowPlayingFullViewController()).environmentObject(musicController.nowPlayingViewModel)
    }
}
