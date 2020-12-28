//
//  NowPlayingBarAnimationView.swift
//  New-Music
//
//  Created by Michael McGrath on 12/11/20.
//

import SwiftUI

struct NowPlayingBarAnimationView: View {
    
    @EnvironmentObject var nowPlayingViewModel: NowPlayingViewModel
    let musicController: MusicController
    var height: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: height - 5, height: height - 5, alignment: .center)
                GeometryReader { geo in
                    HStack(alignment: .center) {
                        VStack(alignment: .leading) {
//                            Text(nowPlayingViewModel.artist)
                            Text("Fall Out Boy")
                                .font(Font.system(.subheadline).weight(.light))
                                .foregroundColor(.lightTextColor)
                                .lineLimit(1)
//                            Text(nowPlayingViewModel.songTitle)
                            Text("Nobody Puts Baby in the Corner" )
                                .font(Font.system(.headline).weight(.light))
                                .foregroundColor(.white)
                                .lineLimit(1)
                        }
                        .frame(maxWidth: height * 3.5)
                        HStack(spacing: 12) {
                            BarPlayPauseButton(isPlaying: nowPlayingViewModel.isPlaying, musicController: musicController, size: height - 5)
                                .foregroundColor(.white)
                                .frame(width: height - 5, height: height - 5, alignment: .center)
                            BarTrackButton(size: height - 16, buttonType: .trackForward, musicController: musicController)
                                .frame(width: height - 16, height: height - 16, alignment: .center)
                        }
                    }
                    .frame(height: geometry.size.height + 2.5, alignment: .center)
                    .padding(.trailing, 15)
                }
                .frame(width: UIScreen.main.bounds.width - 20 - (height - 5) - 8, height: geometry.size.height, alignment: .center)
            }
            .padding(.leading, 20)
            .background(Color.nowPlayingBG.opacity(1))
        }
        .frame(width: UIScreen.main.bounds.width, height: height, alignment: .center)
    }
}

struct NowPlayingBarAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        let musicController = MusicController()
        NowPlayingBarAnimationView(musicController: musicController, height: 65).environmentObject(musicController.nowPlayingViewModel)
    }
}
