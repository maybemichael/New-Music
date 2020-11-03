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
    var fullScreenDelegate: FullScreenNowPlaying?
    
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
                BarPlayPauseButton(isPlaying: nowPlayingViewModel.isPlaying, musicController: musicController, labelPadding: UIScreen.main.bounds.width / 7 / 3, size: UIScreen.main.bounds.width / 7)
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

struct TabBarBackgroundView: View {
    @EnvironmentObject var nowPlayingViewModel: NowPlayingViewModel
    
    var body: some View {
        ZStack {
//            backgroundColorFor(isTooLight: nowPlayingViewModel.isTooLight).opacity(0.35)
            Color.nowPlayingBG.opacity(0.45)
                .edgesIgnoringSafeArea(.all)
        }
//        .background(backgroundColorFor(isTooLight: nowPlayingViewModel.isTooLight))
    }
    
    private func backgroundColorFor(isTooLight: Bool) -> Color {
        isTooLight ? nowPlayingViewModel.darkerAccentColor : nowPlayingViewModel.lighterAccentColor
    }
}
