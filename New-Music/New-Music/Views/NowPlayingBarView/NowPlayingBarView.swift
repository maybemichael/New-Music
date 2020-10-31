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
//    let namespace: Namespace.ID
    @Namespace var namespace
//    @Binding var isPresented: Bool
    var fullScreenDelegate: FullScreenNowPlaying?
    var body: some View {
        ZStack {
            Color.clear.opacity(0)
            HStack(spacing: 10) {
                Spacer()
                NeuAlbumArtworkView(shape: Rectangle(), size: UIScreen.main.bounds.width / 7)
                    .matchedGeometryEffect(id: "AlbumArtwork", in: namespace, properties: .frame, isSource: false)
                VStack(alignment: .leading) {
                    Text(nowPlayingViewModel.songTitle)
                        .font(Font.system(.headline).weight(.light))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .matchedGeometryEffect(id: "SongTitle", in: namespace, properties: .position, isSource: false)
                    Text(nowPlayingViewModel.artist)
                        .font(Font.system(.subheadline).weight(.light))
                        .foregroundColor(.lightTextColor)
                        .lineLimit(1)
                        .matchedGeometryEffect(id: "Artist", in: namespace, properties: .frame, isSource: false)
                }
                .frame(maxWidth: (UIScreen.main.bounds.width / 7) * 2.87, alignment: .leading)
                BarPlayPauseButton(isPlaying: nowPlayingViewModel.isPlaying, musicController: musicController, labelPadding: UIScreen.main.bounds.width / 7 / 3, size: UIScreen.main.bounds.width / 7, namespace: namespace)
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width / 7, height: UIScreen.main.bounds.width / 7, alignment: .center)
                    .matchedGeometryEffect(id: "PlayButton", in: namespace, properties: .position, isSource: false)
                BarTrackButton(size: UIScreen.main.bounds.width / 8.5, trackDirection: .trackForward, musicController: musicController)
                    .matchedGeometryEffect(id: "TrackForward", in: namespace, properties: .frame, isSource: false)
                    .matchedGeometryEffect(id: "TrackBackward", in: namespace, properties: .frame, isSource: false)
            }
            .background(Color.nowPlayingBG.opacity(0))
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 11 + 20)
    }
}


struct NowPlayingBarView_Previews: PreviewProvider {
    static var previews: some View {
        let musicController = MusicController()
        NowPlayingBarView(musicController: musicController, fullScreenDelegate: NowPlayingBarViewController()).environmentObject(musicController.nowPlayingViewModel)
    }
}
