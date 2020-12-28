//
//  NowPlayingBar.swift
//  New-Music
//
//  Created by Michael McGrath on 10/18/20.
//

import SwiftUI

struct NowPlayingBar: View {
    var musicController: MusicController
    let full = ViewControllerWrapper(viewController: NowPlayingFullViewController())
    @EnvironmentObject var songViewModel: NowPlayingViewModel
    @State var isPresented: Bool = false
    @State var isFullScreen: Bool
    let namespace: Namespace.ID
    var body: some View {
        
        ZStack(alignment: .bottom) {
            HStack(alignment: .center) {
                NeuAlbumArtworkView(shape: Rectangle(), size: 65)
                    .matchedGeometryEffect(id: "AlbumArtwork", in: namespace, properties: .frame, isSource: true)
                VStack(alignment: .leading) {
                    Text(songViewModel.songTitle)
                        .font(Font.system(.headline).weight(.light))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .matchedGeometryEffect(id: "Artist", in: namespace, properties: .position, isSource: true)
                    Text(songViewModel.artist)
                        .font(Font.system(.subheadline).weight(.light))
                        .foregroundColor(.lightTextColor)
                        .lineLimit(1)
                        .matchedGeometryEffect(id: "SongTitle", in: namespace, properties: .frame, isSource: true)
                }
                .frame(width: 150, alignment: .leading)
                BarPlayButton(isPlaying: songViewModel.isPlaying, musicController: musicController, size: 60, symbolConfig: .barPlayButton)
                    .matchedGeometryEffect(id: "PlayButton", in: namespace, properties: .size, isSource: false)
                BarTrackButton(size: 45, buttonType: .trackForward, musicController: musicController)
                    .matchedGeometryEffect(id: "TrackBackward", in: namespace, properties: .size, isSource: true)
                    .matchedGeometryEffect(id: "TrackForward", in: namespace, properties: .size, isSource: true)
            }
            .frame(alignment: .bottom)
        }
        .onTapGesture {
            isPresented = true
        }
//        .fullScreenCover(isPresented: $isPresented, content: {
//            ViewControllerWrapper(viewController: NowPlayingViewController())
//            full
//                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//                .background(Color.nowPlayingBG)
//        })
//        .background(Color.nowPlayingBG)
//        .frame(width: UIScreen.main.bounds.width, height: 100, alignment: .center)
//                    HandleIndicator(width: UIScreen.main.bounds.width / 50, height: 6)
//                        .matchedGeometryEffect(id: "HandleIndicator", in: namespace, properties: .size)
//                }
    }
}

struct NowPlayingBar_Previews: PreviewProvider {
    static var previews: some View {
        let nspace = Namespace()
        let musicController = MusicController()
        NowPlayingBar(musicController: musicController, isFullScreen: true, namespace: nspace.wrappedValue).environmentObject(musicController.nowPlayingViewModel)
    }
}

struct BarPlayButton: View {
    @EnvironmentObject var songViewModel: NowPlayingViewModel
    @State var isPlaying: Bool
    var musicController: MusicController
    var size: CGFloat
    var symbolConfig: UIImage.SymbolConfiguration
    
    var body: some View {
        Toggle(isOn: $isPlaying) {
            Image(systemName: songViewModel.isPlaying ? "pause" : "play.fill")
                .resizable()
                .foregroundColor(imageTint(isTooLight: songViewModel.isTooLight))
                .aspectRatio(contentMode: .fit)
                .font(Font.system(.callout).weight(.black))
                .frame(width: 20, height: 20)
                
        }
        .toggleStyle(ToggleButtonStyle(musicController: musicController, size: size))
    }
    
    private func imageTint(isTooLight: Bool) -> Color {
        isTooLight ? .black : .white
    }
    private func symbolForState() -> UIImage {
        guard
            let play = UIImage(systemName: "play.fill", withConfiguration: symbolConfig),
            let pause = UIImage(systemName: "pause", withConfiguration: symbolConfig)
        else { return UIImage() }
        return isPlaying ? pause : play
    }
}

struct BarNeuTrackButton: View {
    @EnvironmentObject var songViewModel: NowPlayingViewModel
    var imageName: String
    var size: CGFloat
    var trackDirection: NeuButtonType
    var musicController: MusicController
    
    var body: some View {
        Button(action: {
            musicController.nextTrack()
        }) {
            Image(systemName: imageName)
                .resizable()
                .foregroundColor(imageTint(isTooLight: songViewModel.isTooLight))
                .aspectRatio(contentMode: .fit)
                .font(Font.system(.headline).weight(.semibold))
                .frame(width: 20, height: 20)
        }
        .frame(width: size, height: size)
        .buttonStyle(NeuButtonStyle(size: size))
    }
    private func imageTint(isTooLight: Bool) -> Color {
        isTooLight ? Color.black : Color.white
    }
}

struct HandleIndicator: View {
    @EnvironmentObject private var songViewModel: NowPlayingViewModel
    var width: CGFloat
    var height: CGFloat

    var body: some View {
        RoundedRectangle(cornerRadius: height / 2)
            .fill(Color.white)
            .overlay(RoundedRectangle(cornerRadius: 5)
                .stroke(songViewModel.darkerAccentColor, lineWidth: 1))
            .frame(width: width, height: height)
    }
}

