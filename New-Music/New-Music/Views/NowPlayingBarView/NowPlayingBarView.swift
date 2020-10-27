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
    let namespace: Namespace.ID
    var body: some View {
        HStack(spacing: 10) {
            NeuAlbumArtworkView(shape: Rectangle(), size: UIScreen.main.bounds.width / 6)
                .matchedGeometryEffect(id: "AlbumArtwork", in: namespace, properties: .frame, isSource: true)
            VStack(alignment: .leading) {
                Text(nowPlayingViewModel.songTitle)
                    .font(Font.system(.headline).weight(.light))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .matchedGeometryEffect(id: "SongTitle", in: namespace, properties: .frame, isSource: true)
                Text(nowPlayingViewModel.artist)
                    .font(Font.system(.subheadline).weight(.light))
                    .foregroundColor(.lightTextColor)
                    .lineLimit(1)
                    .matchedGeometryEffect(id: "Artist", in: namespace, properties: .frame, isSource: true)
            }
            .frame(minWidth: 150)
            HStack(spacing: 20) {
                NeuPlayPauseButton(isPlaying: nowPlayingViewModel.isPlaying, musicController: musicController, labelPadding: 22, size: UIScreen.main.bounds.width / 6)
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width / 6, height: UIScreen.main.bounds.width / 6, alignment: .center)
                    .matchedGeometryEffect(id: "PlayButton", in: namespace, properties: .frame, isSource: false)
                //                .padding(.trailing)
                TrackButton(size: UIScreen.main.bounds.width / 8, trackDirection: .trackForward, musicController: musicController)
                    .matchedGeometryEffect(id: "TrackForward", in: namespace, properties: .frame, isSource: true)
                    .matchedGeometryEffect(id: "TrackBackward", in: namespace, properties: .frame, isSource: true)
            }
        }
        
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 10, alignment: .center)
        .background(Color.nowPlayingBG)
    }
}

struct NowPlayingBarView_Previews: PreviewProvider {
    static var previews: some View {
        let musicController = MusicController()
        let namespace = Namespace()
        NowPlayingBarView(musicController: musicController, namespace: namespace.wrappedValue).environmentObject(musicController.nowPlayingViewModel)
    }
}
