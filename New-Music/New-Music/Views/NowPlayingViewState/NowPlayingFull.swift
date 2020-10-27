//
//  NowPlayingFull.swift
//  New-Music
//
//  Created by Michael McGrath on 10/24/20.
//

import SwiftUI

struct NowPlayingFull: View {
    var musicController: MusicController
    @EnvironmentObject var songViewModel: NowPlayingViewModel
    let topInset = UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.safeAreaInsets.top
    let namespace: Namespace.ID
    
    var body: some View {
        VStack(spacing: 30) {
            HandleIndicator(width: UIScreen.main.bounds.width / 11, height: 6)
                .frame(alignment: .top)
                .matchedGeometryEffect(id: "HandleIndicator", in: namespace)
            NeuAlbumArtworkView(shape: Rectangle(), size: 325)
                .matchedGeometryEffect(id: "AlbumArtwork", in: namespace, properties: .frame, isSource: false)
            VStack {
                Text(songViewModel.songTitle)
                    .font(Font.system(.title3).weight(.light))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .matchedGeometryEffect(id: "Artist", in: namespace, properties: .frame, isSource: false)
                Text(songViewModel.artist)
                    .font(Font.system(.headline).weight(.semibold))
                    .foregroundColor(.lightTextColor)
                    .multilineTextAlignment(.center)
                    .matchedGeometryEffect(id: "SongTitle", in: namespace, properties: .frame, isSource: false)
            }
//            .frame(minHeight: 60)
            .padding(.horizontal, 40)
            
            TrackProgressView(musicController: musicController)
//                .padding(.bottom, 12)
            HStack(spacing: 40) {
                TrackButton(size: 60, trackDirection: .trackBackward, musicController: musicController)
                    .matchedGeometryEffect(id: "TrackBackward", in: namespace, properties: .frame, isSource: true)
                NeuPlayPauseButton(isPlaying: songViewModel.isPlaying, musicController: musicController, labelPadding: 30, size: 90)
                    .frame(width: 90, height: 90)
                    .matchedGeometryEffect(id: "PlayButton", in: namespace, properties: .frame, isSource: true)
                TrackButton(size: 60, trackDirection: .trackForward, musicController: musicController)
                    .matchedGeometryEffect(id: "TrackForward", in: namespace, properties: .frame, isSource: true)
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
        .padding(.bottom, topInset)
        .background(LinearGradient(direction: .diagonalTopToBottom, .sysGraySix, .nowPlayingBG))
    }
}

struct NowPlayingFull_Previews: PreviewProvider {
    static var previews: some View {
        let musicController = MusicController()
        NowPlayingFull(musicController: musicController, namespace: Namespace().wrappedValue).environmentObject(musicController.nowPlayingViewModel)
    }
}
