//
//  NowPlayingBarView.swift
//  New-Music
//
//  Created by Michael McGrath on 10/27/20.
//

import SwiftUI

struct NowPlayingBarView: View {
    @EnvironmentObject var nowPlayingViewModel: NowPlayingViewModel
    let musicController: MusicController
    
    var body: some View {
        ZStack {
            Color.clear.opacity(0)
                .edgesIgnoringSafeArea(.all)
            HStack(spacing: 10) {
                Spacer()
                NeuAlbumArtworkView(shape: Rectangle(), size: UIScreen.main.bounds.width / 7)
                VStack(alignment: .leading) {
                    Text(nowPlayingViewModel.artist)
                        .font(Font.system(.subheadline).weight(.light))
                        .foregroundColor(.lightTextColor)
                        .lineLimit(1)
                    Text(nowPlayingViewModel.songTitle)
                        .font(Font.system(.headline).weight(.light))
                        .foregroundColor(.white)
                        .lineLimit(1)
                }
                .frame(maxWidth: (UIScreen.main.bounds.width / 7) * 2.87, alignment: .leading)
                BarPlayPauseButton(isPlaying: nowPlayingViewModel.isPlaying, musicController: musicController, size: UIScreen.main.bounds.width / 7)
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width / 7, height: UIScreen.main.bounds.width / 7, alignment: .center)
                BarTrackButton(size: UIScreen.main.bounds.width / 8.5, trackDirection: .trackForward, musicController: musicController)
            }
//            .background(backgroundColorFor(isTooLight: nowPlayingViewModel.isTooLight).opacity(0.25))
            .background(Color.nowPlayingBG.opacity(0.45))
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 11 + 20)
    }
    
    private func backgroundColorFor(isTooLight: Bool) -> Color {
        isTooLight ? nowPlayingViewModel.darkerAccentColor : nowPlayingViewModel.lighterAccentColor
    }
}


struct NowPlayingBarView_Previews: PreviewProvider {
    static var previews: some View {
        let musicController = MusicController()
        NowPlayingBarView(musicController: musicController).environmentObject(musicController.nowPlayingViewModel)
    }
}

struct BackgroundView: View {
    @EnvironmentObject var nowPlayingViewModel: NowPlayingViewModel
    
    var body: some View {
//        if nowPlayingViewModel.isFullScreen {
//            ZStack {
//                Rectangle()
//                    .foregroundColor(Color.blue.opacity(0.4))
//                    .edgesIgnoringSafeArea(.all)
////                Color.blue.opacity(0.4)
//            }
////            .background(Color.blue.opacity(0.4))
////            .edgesIgnoringSafeArea(.all)
//        } else {
            ZStack {
//                Rectangle()
//                    .foregroundColor(Color.nowPlayingBG.opacity(0.4))
//                    .edgesIgnoringSafeArea(.all)
//                Color.blue.opacity(0.7)
//                Color.nowPlayingBG.opacity(0.4)
//                    .edgesIgnoringSafeArea(.all)
//                Color.nowPlayingBG.opacity(0.45)
            }
            .background(backgroundColor(for: nowPlayingViewModel.isTooLight))
            .edgesIgnoringSafeArea(.all)
//        }

    }
    
    private func backgroundColorFor(isTooLight: Bool) -> Color {
        isTooLight ? nowPlayingViewModel.darkerAccentColor.opacity(0.45) : nowPlayingViewModel.lighterAccentColor.opacity(0.45)
    }
    private func backgroundColor(for isTooLight: Bool) -> Color {
        isTooLight ? nowPlayingViewModel.darkerAccentColor.opacity(0.45) : nowPlayingViewModel.lighterAccentColor.opacity(0.45)
    }
}

struct NowPlayingMinimized: View {
    @EnvironmentObject var nowPlayingViewModel: NowPlayingViewModel
    let musicController: MusicController
    var height: CGFloat
    
    var body: some View {
            HStack(spacing: 12) {
                VStack(alignment: .leading) {
                    Text(nowPlayingViewModel.artist)
                        .font(Font.system(.subheadline).weight(.light))
                        .foregroundColor(.lightTextColor)
                        .lineLimit(1)
                    Text(nowPlayingViewModel.songTitle)
                        .font(Font.system(.headline).weight(.light))
                        .foregroundColor(.white)
                        .lineLimit(1)
                }
                .frame(maxWidth: (UIScreen.main.bounds.width / 7) * 3, alignment: .leading)
                HStack(spacing: 15) {
                    BarPlayPauseButton(isPlaying: nowPlayingViewModel.isPlaying, musicController: musicController, size: UIScreen.main.bounds.width / 7)
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width / 7, height: UIScreen.main.bounds.width / 7, alignment: .center)
                    BarTrackButton(size: UIScreen.main.bounds.width / 9, trackDirection: .trackForward, musicController: musicController)
                        .frame(width: UIScreen.main.bounds.width / 9, height: UIScreen.main.bounds.width / 9, alignment: .center)
                }
            }
            .frame(alignment: .leading)
    }
    
    private func backgroundColorFor(isTooLight: Bool) -> Color {
        isTooLight ? nowPlayingViewModel.darkerAccentColor : nowPlayingViewModel.lighterAccentColor
    }
}

struct NowPlayingMinimized_Previews: PreviewProvider {
    static var previews: some View {
        let musicController = MusicController()
        NowPlayingMinimized2(musicController: musicController, height: 65).environmentObject(musicController.nowPlayingViewModel)
    }
}

struct NowPlayingMinimized3: View {
    @EnvironmentObject var nowPlayingViewModel: NowPlayingViewModel
    let musicController: MusicController
    var height: CGFloat
    
    var body: some View {
        HStack(spacing: 12) {
            NeuAlbumArtworkView(shape: Rectangle(), size: height - 5)
//                .onTapGesture {
//                    print("Global Frame: \(geo.frame(in: .global))")
//                }
//                .frame(height: height - 5, alignment: .center)
            VStack(alignment: .leading) {
                Text(nowPlayingViewModel.artist)
                    .font(Font.system(.subheadline).weight(.light))
                    .foregroundColor(.lightTextColor)
                        .lineLimit(1)
                    Text(nowPlayingViewModel.songTitle)
                        .font(Font.system(.headline).weight(.light))
                        .foregroundColor(.white)
                        .lineLimit(1)
                }
                .frame(maxWidth: (height) * 3, alignment: .leading)
                HStack(spacing: 15) {
                    BarPlayPauseButton(isPlaying: nowPlayingViewModel.isPlaying, musicController: musicController, size: height - 5)
                        .foregroundColor(.white)
                        .frame(width: height - 5, height: height - 5, alignment: .center)
                    BarTrackButton(size: height - 16, trackDirection: .trackForward, musicController: musicController)
                        .frame(width: height - 16, height: height - 16, alignment: .center)
                }

        }
        .frame(alignment: .center)
    }
    
    private func backgroundColorFor(isTooLight: Bool) -> Color {
        isTooLight ? nowPlayingViewModel.darkerAccentColor : nowPlayingViewModel.lighterAccentColor
    }
}

struct NowPlayingMinimized2: View {
    @EnvironmentObject var nowPlayingViewModel: NowPlayingViewModel
    let musicController: MusicController
    var height: CGFloat
    
    var body: some View {
        HStack {
            GeometryReader { geo in
                NeuAlbumArtworkView(shape: Rectangle(), size: height - 5)
                    .frame(width: height - 5, height: height - 5, alignment: .center)
                    .onAppear {
                        print("Global Frame: \(geo.frame(in: .global))")
                        nowPlayingViewModel.minimizedImageFrame = geo.frame(in: .global)
                    }
            }
            .frame(width: height - 5, height: height - 5, alignment: .center)
            GeometryReader { geo in
                VStack(alignment: .leading) {
                    Text(nowPlayingViewModel.artist)
//                    Text("Fall Out Boy")
                        .font(Font.system(.subheadline).weight(.light))
                        .foregroundColor(.lightTextColor)
                        .lineLimit(1)
                    Text(nowPlayingViewModel.songTitle)
//                    Text("Nobody Puts Baby in the Corner")
                        .font(Font.system(.headline).weight(.light))
                        .foregroundColor(.white)
                        .lineLimit(1)
                }
                .frame(height: height + 5, alignment: .center)
            }
            HStack(spacing: 12) {
                BarPlayPauseButton(isPlaying: nowPlayingViewModel.isPlaying, musicController: musicController, size: height - 5)
                    .foregroundColor(.white)
                    .frame(width: height - 5, height: height - 5, alignment: .center)
                BarTrackButton(size: height - 16, trackDirection: .trackForward, musicController: musicController)
                    .frame(width: height - 16, height: height - 16, alignment: .center)
            }
        }
        .frame(alignment: .center)
        .padding(.leading, 20)
        .padding(.trailing, 15)
    }
}
