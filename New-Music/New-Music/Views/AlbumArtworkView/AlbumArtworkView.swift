//
//  AlbumArtworkView.swift
//  New-Music
//
//  Created by Michael McGrath on 10/26/20.
//

import SwiftUI

struct AlbumArtworkView: View {
    @EnvironmentObject var nowPlayingViewModel: NowPlayingViewModel
    let namespace: Namespace.ID
    var body: some View {
        NeuAlbumArtworkView(shape: Rectangle(), size: UIScreen.main.bounds.width - 80)
    }
}

struct AlbumArtworkView_Previews: PreviewProvider {
    static var previews: some View {
        let musicController = MusicController()
        let namespace = Namespace()
        AlbumArtworkView(namespace: namespace.wrappedValue).environmentObject(musicController.nowPlayingViewModel)
    }
}

struct NeuAlbumArtworkView<S: Shape>: View {
    @EnvironmentObject var nowPlayingViewModel: NowPlayingViewModel
    @State var image: UIImage = UIImage()
    var shape: S
    var size: CGFloat
    
    var body: some View {
        ZStack {
            Color.clear.opacity(0)
            shape
                .fill(LinearGradient(direction: .diagonalTopToBottom, .sysGraySix, .black))
                .overlay(
                    shape
                        .stroke(Color.black, lineWidth: 4)
                        .blur(radius: 4)
                        .offset(x: 10, y: 10)
                        .mask(shape.fill(LinearGradient(direction: .diagonalTopToBottom, Color.clear, Color.black))))
                .overlay(
                    shape
                        .stroke(Color.nowPlayingBG, lineWidth: 4)
                        .blur(radius: 4)
                        .offset(x: -10, y: -10)
                        .mask(shape.fill(LinearGradient(direction: .diagonalTopToBottom, Color.black, Color.clear))))
                .overlay(shape.stroke(LinearGradient(direction: .diagonalTopToBottom, .sysGrayThree, .black), lineWidth: (size * 0.03)))
                .shadow(color: Color.black.opacity(0.9), radius: 10, x: 5, y: 5)
                .shadow(color: Color.white.opacity(0.1), radius: 10, x: -3, y: -3)
            Image(uiImage: nowPlayingViewModel.albumArtwork ?? UIImage())
                .resizable()
                .frame(width: size - (size * 0.03), height: size - (size * 0.03))
                .scaledToFit()
        }
        .frame(width: size, height: size, alignment: .center)
        .background(Color.clear)
    }
}
