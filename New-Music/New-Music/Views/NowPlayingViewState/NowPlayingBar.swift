//
//  NowPlayingBar.swift
//  New-Music
//
//  Created by Michael McGrath on 10/18/20.
//

import SwiftUI

struct NowPlayingBar: View {
    var musicController: MusicController
    @EnvironmentObject var songViewModel: NowPlayingViewModel
    @State var isPresented: Bool = false
    @State var isFullScreen: Bool
    let namespace: Namespace.ID
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.nowPlayingBG
//            LinearGradient(.sysGrayThree, .nowPlayingBG)
                .edgesIgnoringSafeArea(.all)
            HStack() {
                NeuAlbumArtworkView(shape: Rectangle(), color1: .sysGraySix, color2: .black, size: 65)
                    .matchedGeometryEffect(id: "AlbumArtwork", in: namespace, properties: .frame, isSource: true)
                ZStack(alignment: .leading) {
                    Text(songViewModel.songTitle)
                        .font(Font.system(.headline).weight(.medium))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .frame(width: 150)
                        .matchedGeometryEffect(id: "SongTitle", in: namespace, properties: .position, isSource: true)
                        .matchedGeometryEffect(id: "Artist", in: namespace, properties: .position, isSource: true)
                }
                BarPlayButton(isPlaying: songViewModel.isPlaying, musicController: musicController, size: 60, symbolConfig: .barPlayButton)
                    .matchedGeometryEffect(id: "PlayButton", in: namespace, properties: .frame, isSource: false)
                BarTrackButton(imageName: "forward.fill", size: 45, trackDirection: .trackForward, musicController: musicController)
                    .matchedGeometryEffect(id: "TrackBackward", in: namespace, properties: .size, isSource: true)
                    .matchedGeometryEffect(id: "TrackForward", in: namespace, properties: .frame, isSource: true)
            }
            .padding(20)
        }
//        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 12)
    }
}

struct NowPlayingBar_Previews: PreviewProvider {
    static var previews: some View {
        let nspace = Namespace()
        let musicController = MusicController()
        NowPlayingBar(musicController: musicController, isFullScreen: true, namespace: nspace.wrappedValue)
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
            Image(systemName: isPlaying ? "pause" : "play.fill")
                .resizable()
                .foregroundColor(imageTint(isTooLight: songViewModel.isTooLight))
                .aspectRatio(contentMode: .fit)
                .font(Font.system(.callout).weight(.black))
                .frame(width: 20, height: 20)
                
        }
        .toggleStyle(ToggleButtonStyle(musicController: musicController, size: size, labelPadding: 40))
    }
    
    private func imageTint(isTooLight: Bool) -> Color {
        isTooLight ? .black : .white
    }
    private func symbolForState() -> UIImage {
        guard
            let play = UIImage(systemName: "play.fill", withConfiguration: symbolConfig),
//                ?.withTintColor(imageTint(isTooLight: songViewModel.isTooLight)),
            let pause = UIImage(systemName: "pause", withConfiguration: symbolConfig)
//                ?.withTintColor(imageTint(isTooLight: songViewModel.isTooLight))
        else { return UIImage() }
        return isPlaying ? pause : play
    }
}

struct BarTrackButton: View {
    @EnvironmentObject var songViewModel: NowPlayingViewModel
    var imageName: String
    var size: CGFloat
    var trackDirection: TrackDirection
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
        .buttonStyle(NeuButtonStyle(lighterColor: songViewModel.lighterAccentColor, darkerColor: songViewModel.darkerAccentColor, size: size))
    }
    private func imageTint(isTooLight: Bool) -> Color {
        isTooLight ? Color.black : Color.white
    }
}

struct ModalPopover: View {
    @State private var isPresented = false
    @Environment(\.presentationMode) var presentationMode
    var musicController: MusicController
    @EnvironmentObject var songViewModel: NowPlayingViewModel
    @Namespace var nspace
    var body: some View {
        NowPlayingBar(musicController: musicController, isFullScreen: false, namespace: nspace)
            .onTapGesture(count: 1, perform: {
                isPresented = true
            })
        popover(isPresented: $isPresented, content: {
//            NowPlayingView(musicController: musicController, songViewModel: musicController.nowPlayingViewModel, delegate: self)
        })
    }
}

struct FullScreenModalView: View {
    @Environment(\.presentationMode) var presentationMode
    var musicController: MusicController
    @ObservedObject var songViewModel: NowPlayingViewModel
    
    var body: some View {
        VStack {
//            NowPlayingView(musicController: musicController, songViewModel: musicController.nowPlayingViewModel)
        }
        .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height)
        .background(LinearGradient(.sysGrayThree, .nowPlayingBG))
        .edgesIgnoringSafeArea(.all)
        .onTapGesture {
            presentationMode.wrappedValue.dismiss()
        }
    }
}
