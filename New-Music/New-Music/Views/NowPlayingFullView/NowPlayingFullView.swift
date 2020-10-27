//
//  NowPlayingFullView.swift
//  New-Music
//
//  Created by Michael McGrath on 10/26/20.
//

import SwiftUI

struct NowPlayingFullView: View {
    @EnvironmentObject var nowPlayingViewModel: NowPlayingViewModel
    let musicController: MusicController
    let namespace: Namespace.ID
    
    var body: some View {
        
        VStack {
            AlbumArtworkView(namespace: namespace)
                .padding(.bottom, 20)
                .matchedGeometryEffect(id: "AlbumArtwork", in: namespace, properties: .frame, isSource: false)
            
            Text(nowPlayingViewModel.songTitle)
                .font(Font.system(.title2).weight(.medium))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .matchedGeometryEffect(id: "SongTitle", in: namespace, properties: .frame, isSource: false)
                .padding(.horizontal, 40)
            Text(nowPlayingViewModel.artist)
                .font(Font.system(.headline).weight(.medium))
                .foregroundColor(.lightTextColor)
                .multilineTextAlignment(.center)
                .matchedGeometryEffect(id: "Artist", in: namespace, properties: .frame, isSource: false)
                .padding(.horizontal, 40)
            TrackProgressBarView(musicController: musicController)
            MusicControlsView(musicController: musicController, namespace: namespace)
        }
        
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 20, alignment: .center)
//        .cornerRadius(20)
        //        .background(LinearGradient(direction: .diagonalTopToBottom, .sysGraySix, .nowPlayingBG))
    }
}

struct NowPlayingFullView_Previews: PreviewProvider {
    static var previews: some View {
        let musicController = MusicController()
        let namespace = Namespace()
        NowPlayingFullView(musicController: musicController, namespace: namespace.wrappedValue).environmentObject(musicController.nowPlayingViewModel)
    }
}
