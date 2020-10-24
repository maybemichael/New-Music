//
//  CurrentPlaylistView.swift
//  New-Music
//
//  Created by Michael McGrath on 10/23/20.
//

import SwiftUI

//struct CurrentPlaylistView: View {
////    @ObservedObject var currentPlaylist: CurrentPlaylist
//    @EnvironmentObject var nowPlayingViewModel: NowPlayingViewModel
//    @ObservedObject var currentPlaylist: CurrentPlaylist
//    let musicController: MusicController
//    var delegate: TabBarStatus
//    var body: some View {
//        ZStack {
//            Color.nowPlayingBG
//                .edgesIgnoringSafeArea(.all)
//            
//            VStack {
//                List {
//                    ForEach(currentPlaylist.songs) { song in
//                        PlaylistSongView(songTitle: song.songName, artist: song.artistName, albumArtwork: song.albumArtwork ?? Data())
//                    }
//                }
////                NowPlayingView(musicController: musicController, delegate: delegate, isFullScreen: musicController.nowPlayingViewModel.isFullScreen, height: <#CGFloat#>)
//            }
//        }
//    }
//}

//struct CurrentPlaylistView_Previews: PreviewProvider {
//    var delegate: TabBarStatus
//    static var previews: some View {
//        let musicController = MusicController()
//        CurrentPlaylistView(currentPlaylist: musicController.nowPlayingViewModel.songs, musicController: musicController, delegate: NowPlayingBarViewController()).environmentObject(musicController.nowPlayingViewModel)
//    }
//}
