//
//  PlayingIndicatorView.swift
//  New-Music
//
//  Created by Michael McGrath on 11/19/20.
//

import SwiftUI

struct PlayingIndicatorView: View {
    @ObservedObject var nowPlayingViewModel: NowPlayingViewModel
    @State var animate = false
    var song: Song
    var size: CGFloat
    var body: some View {
        if nowPlayingViewModel.nowPlayingSong?.id == song.id {
            ZStack {
                gradient(for: nowPlayingViewModel.whiteLevel)
                    .mask(Image(systemName: "music.note").resizable().aspectRatio(contentMode: .fit))
            }
            .frame(width: size, height: size, alignment: .center)
            .scaleEffect(self.animate ? 1.0 : 0.5)
            .animation(self.animate ? Animation.linear(duration: 0.8).repeatForever(autoreverses: true) : Animation.linear(duration: 0.4))
            .onAppear {
                if nowPlayingViewModel.isPlaying {
                    self.animate = true
                }
            }
//            .onDisappear {
//                self.animate = false
//            }
            .onChange(of: self.nowPlayingViewModel.isPlaying, perform: { _ in
                if nowPlayingViewModel.isPlaying {
                    self.animate = true
                } else {
                    self.animate = false
                }
            })
        }
    }
    
    private func gradient(for whiteLevel: CGFloat) -> LinearGradient {
//        whiteLevel < 0.15 ? LinearGradient(direction: .diagonalTopToBottom, nowPlayingViewModel.textColor2, nowPlayingViewModel.darkerTextColor2) : LinearGradient(direction: .diagonalTopToBottom, nowPlayingViewModel.lighterAccentColor, nowPlayingViewModel.darkerAccentColor)
        LinearGradient(direction: .diagonalTopToBottom, nowPlayingViewModel.lighterAccentColor, nowPlayingViewModel.darkerAccentColor)
    }
    
    private func opacityForPlayingSong() -> Double {
        if nowPlayingViewModel.nowPlayingSong?.id == song.id {
            return 1.0
        } else {
            return 0
        }
    }
}

struct PlayingIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        PlayingIndicatorView(nowPlayingViewModel: MusicController().nowPlayingViewModel, song: Song(songName: "Merp Merp", artistName: "The Merps", imageURL: URL(string: "https://www.merp.com")!), size: UIScreen.main.bounds.width / 5.5)
    }
}
