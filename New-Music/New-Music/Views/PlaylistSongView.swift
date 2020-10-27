//
//  PlaylistSongView.swift
//  New-Music
//
//  Created by Michael McGrath on 10/23/20.
//

import SwiftUI

struct PlaylistSongView: View {
    
    @EnvironmentObject var nowPlayingViewModel: NowPlayingViewModel
    @State var songTitle: String
    @State var artist: String
    @State var albumArtwork: Data
    var body: some View {
//        VStack() {
//        ZStack {
        HStack(alignment: .center) {
            PlaylistAlbumArtwork(size: UIScreen.main.bounds.width / 7, image: UIImage(data: albumArtwork) ?? UIImage())
            VStack(alignment: .leading) {
                Text(songTitle)
                    .font(Font.system(.headline).weight(.light))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .frame(alignment: .leading)
                Text(artist)
                    .font(Font.system(.subheadline).weight(.light))
                    .foregroundColor(.lightTextColor)
                    .lineLimit(1)
                    .frame(alignment: .leading)
            }
            //                    .frame(minWidth: (UIScreen.main.bounds.width / 7) * 4)
            Spacer(minLength: 20)
            HStack(spacing: 3) {
                Rectangle()
                    .frame(width: 3, height: 3)
                    .foregroundColor(.white)
                Rectangle()
                    .frame(width: 3, height: 3)
                    .foregroundColor(.white)
                Rectangle()
                    .frame(width: 3, height: 3)
                    .foregroundColor(.white)
                Rectangle()
                    .frame(width: 3, height: 3)
                    .foregroundColor(.white)
            }
            Spacer()
        }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 12, alignment: .leading)
//                .background(Color.nowPlayingBG)
    }
}

struct PlaylistSongView_Previews: PreviewProvider {
    static var previews: some View {
        let musicController = MusicController()
        PlaylistSongView(songTitle: "Hold you down", artist: "DJ Khaled", albumArtwork: Data()).environmentObject(musicController.nowPlayingViewModel)
    }
}

struct PlaylistAlbumArtwork: View {
//    @EnvironmentObject var songViewModel: NowPlayingViewModel
    var size: CGFloat
    var image: UIImage
    var data: Data?
    var body: some View {
        ZStack {
            Color.nowPlayingBG
                .edgesIgnoringSafeArea(.all)
            Rectangle()
                .fill(LinearGradient(direction: .diagonalTopToBottom, .nowPlayingBG, .black))
                .overlay(
                    Rectangle()
                        .stroke(Color.black, lineWidth: 4)
                        .blur(radius: 4)
                        .offset(x: 10, y: 10)
                        .mask(Rectangle().fill(LinearGradient(direction: .diagonalTopToBottom, Color.clear, Color.black))))
                .overlay(
                    Rectangle()
                        .stroke(Color.nowPlayingBG, lineWidth: 4)
                        .blur(radius: 4)
                        .offset(x: -10, y: -10)
                        .mask(Rectangle().fill(LinearGradient(direction: .diagonalTopToBottom, Color.black, Color.clear))))
                .overlay(Rectangle().stroke(LinearGradient(direction: .diagonalTopToBottom, .sysGraySix, .black), lineWidth: (size * 0.03)))
                .shadow(color: Color.black.opacity(0.7), radius: 10, x: 5, y: 5)
                .shadow(color: Color.white.opacity(0.08), radius: 10, x: -3, y: -3)
            Image(uiImage: image)
                .resizable()
                .frame(width: size - (size * 0.03), height: size - (size * 0.03))
                .scaledToFit()
        }
        .frame(width: size, height: size)
    }
    func makeImage(data: Data?) -> UIImage {
        if let data = data {
            return UIImage(data: data) ?? UIImage()
        } else {
            return UIImage()
        }
    }
}


