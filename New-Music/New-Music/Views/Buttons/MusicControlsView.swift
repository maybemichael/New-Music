//
//  MusicControlsView.swift
//  New-Music
//
//  Created by Michael McGrath on 10/26/20.
//

import SwiftUI

struct MusicControlsView: View {
    @EnvironmentObject private var nowPlayingViewModel: NowPlayingViewModel
    var musicController: MusicController
    let namespace: Namespace.ID
    var body: some View {
        HStack(spacing: 45) {
            NeuTrackButton(size: UIScreen.main.bounds.width / 7, trackDirection: .trackBackward, musicController: musicController)
//                .matchedGeometryEffect(id: "TrackBackward", in: namespace, properties: .frame)
            NeuPlayPauseButton(isPlaying: nowPlayingViewModel.isPlaying, musicController: musicController, labelPadding: 30, size: UIScreen.main.bounds.width / 4.7)
                .frame(width: UIScreen.main.bounds.width / 4.7, height: UIScreen.main.bounds.width / 4.7)
//                .matchedGeometryEffect(id: "PlayButton", in: namespace, properties: .frame)
            NeuTrackButton(size: UIScreen.main.bounds.width / 7, trackDirection: .trackForward, musicController: musicController)
//                .matchedGeometryEffect(id: "TrackForward", in: namespace, properties: .frame)
        }
    }
}

struct MusicControlsView_Previews: PreviewProvider {
    static var previews: some View {
        let musicController = MusicController()
        let namespace = Namespace()
        MusicControlsView(musicController: musicController, namespace: namespace.wrappedValue).environmentObject(musicController.nowPlayingViewModel)
    }
}
