//
//  NowPlayingPlaylistView.swift
//  New-Music
//
//  Created by Michael McGrath on 10/30/20.
//

import SwiftUI

struct NowPlayingPlaylistView: View {
    @EnvironmentObject var nowPlayingViewModel: NowPlayingViewModel
    var body: some View {
        List {
            ForEach(nowPlayingViewModel.songs) { song in
                PlaylistSongView(songTitle: song.songName, artist: song.artistName, albumArtwork: song.albumArtwork ?? Data())
            }.listRowBackground(Color.nowPlayingBG)
        }
        .frame(alignment: .top)
        .onAppear {
            UITableView.appearance().separatorStyle = .singleLine
            UITableView.appearance().backgroundColor = UIColor.backgroundColor
            UITableView.appearance().separatorColor = UIColor.white
            UITableViewCell.appearance().contentView.backgroundColor = UIColor.backgroundColor
            UITableViewCell.appearance().backgroundColor = UIColor.backgroundColor
        }
    }
}

struct NowPlayingPlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        let musicController = MusicController()
        NowPlayingPlaylistView().environmentObject(musicController.nowPlayingViewModel)
    }
}
