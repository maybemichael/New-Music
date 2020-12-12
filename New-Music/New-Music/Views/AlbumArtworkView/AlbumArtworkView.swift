//
//  AlbumArtworkView.swift
//  New-Music
//
//  Created by Michael McGrath on 10/26/20.
//

import SwiftUI

struct AlbumArtworkView: View {
    @EnvironmentObject var nowPlayingViewModel: NowPlayingViewModel
    var body: some View {
        NeuAlbumArtworkView(shape: Rectangle(), size: UIScreen.main.bounds.width - 80)
    }
}

struct AlbumArtworkView_Previews: PreviewProvider {
    static var previews: some View {
        let musicController = MusicController()
        AlbumArtworkView().environmentObject(musicController.nowPlayingViewModel)
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
    }
}

struct ArtworkView: View {
    @EnvironmentObject var nowPlayingViewModel: NowPlayingViewModel
    @State var image: UIImage = UIImage()
    var body: some View {
        ZStack {
            Color.clear.opacity(0)
            Rectangle()
                .fill(LinearGradient(direction: .diagonalTopToBottom, .sysGraySix, .black))
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
                .overlay(Rectangle().stroke(LinearGradient(direction: .diagonalTopToBottom, .sysGrayThree, .black), lineWidth: nowPlayingViewModel.isFull ? (UIScreen.main.bounds.width - 80) * 0.03 : (UIScreen.main.bounds.width / 7) * 0.03))
                .shadow(color: Color.black.opacity(0.9), radius: 10, x: nowPlayingViewModel.isFull ? 5 : 2, y: nowPlayingViewModel.isFull ? 5 : 2)
                .shadow(color: Color.white.opacity(0.1), radius: 10, x: nowPlayingViewModel.isFull ? -3 : -1, y: nowPlayingViewModel.isFull ? -3 : -1)
            Image(uiImage: nowPlayingViewModel.albumArtwork ?? UIImage())
                .resizable()
                .frame(width: artworkWidth(for: nowPlayingViewModel.isFull) - (artworkWidth(for: nowPlayingViewModel.isFull) * 0.03), height: artworkWidth(for: nowPlayingViewModel.isFull) - (artworkWidth(for: nowPlayingViewModel.isFull) * 0.05))
                .scaledToFit()
        }
    }
    
    private func artworkWidth(for state: Bool) -> CGFloat {
        nowPlayingViewModel.isFull ? UIScreen.main.bounds.width - 80 : UIScreen.main.bounds.width / 7
    }
}

struct ArtworkView2: View {
    @EnvironmentObject var nowPlayingViewModel: NowPlayingViewModel
    @State var image: UIImage = UIImage()
    var size: CGFloat
    var body: some View {
        
        GeometryReader { geo in
            ZStack {
                Color.clear.opacity(0)
                Rectangle()
                    .fill(LinearGradient(direction: .diagonalTopToBottom, .sysGraySix, .black))
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
                    .overlay(Rectangle().stroke(LinearGradient(direction: .diagonalTopToBottom, .sysGrayThree, .black), lineWidth: size * 0.03))
                    .shadow(color: Color.black.opacity(0.9), radius: 10, x: 5, y: 5)
                    .shadow(color: Color.white.opacity(0.1), radius: 10, x: -3, y: -3)
                Image(uiImage: nowPlayingViewModel.albumArtwork ?? UIImage())
                    .resizable()
                    .frame(width: geo.size.width - (geo.size.width * 0.03), height: geo.size.height - (geo.size.height * 0.03), alignment: .center)
                    .scaledToFit()
            }
        }
        .frame(width: size, height: size, alignment: .center)
    }
    
    private func artworkWidth(for state: Bool) -> CGFloat {
        nowPlayingViewModel.isFull ? UIScreen.main.bounds.width - 80 : UIScreen.main.bounds.width / 7
    }
}

struct ArtworkAnimationView: View {
    @EnvironmentObject var nowPlayingViewModel: NowPlayingViewModel
    @State var image: UIImage = UIImage()
    var size: CGFloat
    var body: some View {
        
        GeometryReader { geo in
            ZStack {
                Color.clear.opacity(0)
                Rectangle()
                    .fill(LinearGradient(direction: .diagonalTopToBottom, .sysGraySix, .black))
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
                    .overlay(Rectangle().stroke(LinearGradient(direction: .diagonalTopToBottom, .sysGrayThree, .black), lineWidth: size * 0.03))
                    .shadow(color: Color.black.opacity(0.8), radius: 10, x: 5, y: 5)
                    .shadow(color: Color.white.opacity(0.1), radius: 10, x: -3, y: -3)
                Image(uiImage: nowPlayingViewModel.albumArtwork ?? UIImage())
                    .resizable()
                    .frame(width: geo.size.width - (geo.size.width * 0.03), height: geo.size.height - (geo.size.height * 0.03), alignment: .center)
                    .scaledToFit()
            }
        }
        .frame(width: size, height: size, alignment: .center)
    }
    
    private func artworkWidth(for state: Bool) -> CGFloat {
        nowPlayingViewModel.isFull ? UIScreen.main.bounds.width - 80 : UIScreen.main.bounds.width / 7
    }
}
