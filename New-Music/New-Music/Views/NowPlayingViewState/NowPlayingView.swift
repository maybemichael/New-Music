//
//  NowPlayingView.swift
//  New-Music
//
//  Created by Michael McGrath on 10/4/20.
//

import SwiftUI
import MediaPlayer

struct NowPlayingView: View {
    var musicController: MusicController
    @EnvironmentObject var songViewModel: NowPlayingViewModel
    @GestureState private var dragState = DragState.inactive
    @State var position: CGFloat = 0
    @State var isFullScreen: Bool = false
    @State var bottomAnchor = UIScreen.main.bounds.height
    @State var topAnchor: CGFloat = 0
    @State var cardBottomEdgeLocation: CGFloat = UIScreen.main.bounds.height
    @Namespace var namespace
    var delegate: TabBarStatus
    let topInset = UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.safeAreaInsets.top
    let bottomInset = UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.safeAreaInsets.bottom
    let height: CGFloat
    let tabBarHeight: CGFloat
    var drag: some Gesture {
        let drag = DragGesture()
            .updating($dragState) { drag, state, transaction in
                state = .dragging(translation: drag.translation)
                
                
            }
            .onEnded(onDragEnded)
        return drag
    }
    
    var body: some View {
        if songViewModel.isFullScreen {
            NowPlayingFull(musicController: musicController, namespace: namespace, isPresented: $isFullScreen)
                .cornerRadius(15.0)
                .offset(y: setOffset())
                .animation(self.dragState.isDragging ? nil : .interpolatingSpring(stiffness: 400.0, damping: 50.0, initialVelocity: 7))
                .gesture(drag)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 20)
                .background(Color.nowPlayingBG)
                .transition(.move(edge: .bottom))
                .matchedGeometryEffect(id: "NowPlayingView", in: namespace, properties: .frame, isSource: false)
        } else {
            ZStack(alignment: .bottom) {
                Color.nowPlayingBG
                    .edgesIgnoringSafeArea(.all)
                VStack {
//                    List {
//                        ForEach(songViewModel.songs) { song in
//                            PlaylistSongView(songTitle: song.songName, artist: song.artistName, albumArtwork: song.albumArtwork ?? Data())
//                        }.listRowBackground(Color.nowPlayingBG)
//                    }
//                    .frame(width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height / 9) * 6, alignment: .leading)
                    
//                    .onAppear {
//                        UITableView.appearance().separatorStyle = .singleLine
//                        UITableView.appearance().backgroundColor = UIColor.backgroundColor
//                        UITableView.appearance().separatorColor = UIColor.white
//                        UITableViewCell.appearance().contentView.backgroundColor = UIColor.backgroundColor
//                        UITableViewCell.appearance().backgroundColor = UIColor.backgroundColor
//                        UITableView.appearance().tintColor = UIColor.clear
//                    }

                    ZStack {
                        Rectangle()
                            .fill(Color.nowPlayingBG.opacity(0.85))
                        NowPlayingBar(musicController: musicController, isFullScreen: false, namespace: namespace)
                            .matchedGeometryEffect(id: "NowPlayingView", in: namespace, properties: .frame, isSource: true)
                    }
                    .background(Color.clear)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 9)
                    .onTapGesture(perform: {
                        withAnimation(Animation.easeOut(duration: 0.3)) {
                            songViewModel.isFullScreen = true
                            self.delegate.toggleHidden(isFullScreen: songViewModel.isFullScreen, viewController: nil)
                            self.position = CardPosition.top.offset
                                
                        }
                    })
                }
            }
            .transition(.move(edge: .top))
        }
    }
    
    func setOffset() -> CGFloat {
        if self.topAnchor < 0 {
            return 0
        }
        if self.cardBottomEdgeLocation < UIScreen.main.bounds.height {
            return UIScreen.main.bounds.height
        }
        return self.position + self.dragState.translation.height
    }
    
    private func onDragEnded(drag: DragGesture.Value) {
        let verticalDirection = drag.predictedEndLocation.y - drag.location.y
        topAnchor = self.position + drag.translation.height
        cardBottomEdgeLocation = self.bottomAnchor + drag.translation.height
        let positionAbove: CGFloat = CardPosition.top.offset
        let positionBelow: CGFloat = CardPosition.bottom.offset
        let closestPosition: CGFloat
        
        if verticalDirection > 40 {
            withAnimation {
                songViewModel.isFullScreen = true
            }
        }

        if (topAnchor - positionAbove) < (positionBelow - topAnchor) {
            closestPosition = positionAbove
        } else {
            closestPosition = positionBelow
        }
        
        if verticalDirection > 0 {
            self.position = positionBelow
        } else if verticalDirection < 0 {
            self.position = positionAbove
        } else {
            self.position = closestPosition
        }
        
        if self.position > CardPosition.middle.offset {
            withAnimation {
                songViewModel.isFullScreen = false
                delegate.toggleHidden(isFullScreen: songViewModel.isFullScreen, viewController: nil)
                self.position = CardPosition.bottom.offset
            }
        } else {
            withAnimation {
                songViewModel.isFullScreen = true
                delegate.toggleHidden(isFullScreen: songViewModel.isFullScreen, viewController: nil)
                self.position = CardPosition.top.offset
            }
        }
    }
    
    private func getListHeight() -> CGFloat {
        guard
            let topInset = self.topInset,
            let bottomInset = self.bottomInset
        else { return UIScreen.main.bounds.height / 1.2 }
        return self.height - (topInset + bottomInset)
    }
    
    init(musicController: MusicController, delegate: TabBarStatus, isFullScreen: Bool, height: CGFloat, tabBarHeight: CGFloat) {
        self.musicController = musicController
        self.delegate = delegate
//        self.isFullScreen = false
        self.height = height
        self.tabBarHeight = tabBarHeight
        UITableView.appearance().separatorStyle = .singleLine
        UITableView.appearance().backgroundColor = UIColor.backgroundColor
        UITableView.appearance().separatorColor = UIColor.white
        UITableViewCell.appearance().contentView.backgroundColor = UIColor.backgroundColor
        UITableViewCell.appearance().backgroundColor = UIColor.backgroundColor
    }
}

//struct NowPlayingView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        let musicController = MusicController()
//        let nspace = Namespace()
//        NowPlayingView(musicController: musicController, namespace: nspace, delegate: NowPlayingBarViewController())
//
//    }
//}

//struct NeuButtonBackground<S: Shape>: View {
//    @State var isHighlighted: Bool
//    var shape: S
//    var size: CGFloat
//    @EnvironmentObject var songViewModel: NowPlayingViewModel
//
//    var body: some View {
//        ZStack {
//            if songViewModel.whiteLevel < 0.3 {
//                if isHighlighted {
//                    shape
//                        .fill(gradient(for: isHighlighted))
//                        .overlay(
//                            shape
//                                .stroke(songViewModel.lighterAccentColor, lineWidth: 2)
//                                .blur(radius: 4)
//                                .offset(x: -2, y: -2)
//                                .mask(shape.fill(LinearGradient(direction: .diagonalTopToBottom, Color.clear, Color.black))))
//                        .overlay(
//                            shape
//                                .stroke(songViewModel.darkerAccentColor, lineWidth: 2)
//                                .blur(radius: 8)
//                                .offset(x: -2, y: -2)
//                                .mask(shape.fill(LinearGradient(direction: .diagonalTopToBottom, Color.black, Color.clear))))
//                        .shadow(color: Color.black.opacity(0.5), radius: 10, x: 7, y: 7)
//                        .shadow(color: Color.white.opacity(0.5), radius: 10, x: -7, y: -7)
//                        .blendMode(.overlay)
//                    shape
//                        .fill(gradient(for: isHighlighted))
//                        .overlay(shape.stroke(LinearGradient(direction: .diagonalTopToBottom, .blackGradient, .black), lineWidth: 2))
//                } else {
//                    shape
//                        .fill(gradient(for: isHighlighted))
//                        .shadow(color: Color.black.opacity(0.5), radius: 10, x: 10, y: 10)
//                        .shadow(color: Color.white.opacity(0.5), radius: 10, x: -10, y: -10)
//                        .blendMode(.overlay)
//                    shape
//                        .fill(LinearGradient(direction: .diagonalTopToBottom, songViewModel.lighterAccentColor, songViewModel.darkerAccentColor))
//                        .overlay(shape.stroke(LinearGradient(direction: .diagonalTopToBottom, .blackGradient, .black), lineWidth: 2))
//                }
//            } else {
//                if isHighlighted {
//                    shape
//                        .fill(gradient(for: isHighlighted))
//                        .overlay(
//                            shape
//                                .stroke(songViewModel.lighterAccentColor, lineWidth: 2)
//                                .blur(radius: 4)
//                                .offset(x: -2, y: -2)
//                                .mask(shape.fill(LinearGradient(direction: .diagonalTopToBottom, Color.clear, Color.black))))
//                        .overlay(
//                            shape
//                                .stroke(songViewModel.darkerAccentColor, lineWidth: 2)
//                                .blur(radius: 8)
//                                .offset(x: -2, y: -2)
//                                .mask(shape.fill(LinearGradient(direction: .diagonalTopToBottom, Color.black, Color.clear))))
//                        .shadow(color: Color.black.opacity(0.7), radius: 8, x: 7, y: 7)
//                        .shadow(color: Color.white.opacity(0.8), radius: 8, x: -7, y: -7)
//                        .blendMode(.overlay)
//                    shape
//                        .fill(gradient(for: isHighlighted))
//                        .overlay(shape.stroke(LinearGradient(direction: .diagonalTopToBottom, .blackGradient, .black), lineWidth: 2))
//                } else {
//                    shape
//                        .fill(gradient(for: isHighlighted))
//                        .shadow(color: Color.black.opacity(0.7), radius: 8, x: 10, y: 10)
//                        .shadow(color: Color.white.opacity(0.8), radius: 8, x: -10, y: -10)
//                        .blendMode(.overlay)
//                    shape
//                        .fill(LinearGradient(direction: .diagonalTopToBottom, songViewModel.lighterAccentColor, songViewModel.darkerAccentColor))
//                        .overlay(shape.stroke(LinearGradient(direction: .diagonalTopToBottom, .blackGradient, .black), lineWidth: 2))
//                }
//            }
//        }
//        .frame(width: size, height: size)
//    }
//
//    private func gradient(for state: Bool) -> LinearGradient {
//        state ? LinearGradient(direction: .diagonalTopToBottom, songViewModel.darkerAccentColor, songViewModel.lighterAccentColor) : LinearGradient(direction: .diagonalTopToBottom, songViewModel.darkerAccentColor, songViewModel.lighterAccentColor)
//    }
//}

//struct NeuButtonStyle: ButtonStyle {
//    @EnvironmentObject var songViewModel: NowPlayingViewModel
//    var lighterColor: Color
//    var darkerColor: Color
//    var size: CGFloat
//
//    func makeBody(configuration: Self.Configuration) -> some View {
//        configuration.label
//            .padding(30)
//            .contentShape(Circle())
//            .background(NeuButtonBackground(isHighlighted: configuration.isPressed, shape: Circle(), size: size))
//    }
//}

//struct TrackButton: View {
//    var imageName: String
//    var size: CGFloat
//    var trackDirection: TrackDirection
//    var musicController: MusicController
//    @EnvironmentObject var songViewModel: NowPlayingViewModel
//    
//    var body: some View {
//        Button(action: {
//            trackDirection == .trackForward ? musicController.nextTrack() : musicController.previousTrack()
//        }) {
//            Image(systemName: imageName)
//                .foregroundColor(imageTint(isTooLight: songViewModel.isTooLight))
//                .aspectRatio(contentMode: .fit)
//                .font(Font.system(.headline).weight(.semibold))
//        }
//        .frame(width: size, height: size)
//        .buttonStyle(NeuButtonStyle(lighterColor: songViewModel.lighterAccentColor, darkerColor: songViewModel.darkerAccentColor, size: size))
//    }
//    func imageTint(isTooLight: Bool) -> Color {
//        isTooLight ? Color.black : Color.white
//    }
//}

//struct NeuToggleBackground<S: Shape>: View {
//    @EnvironmentObject var songViewModel: NowPlayingViewModel
//    var shape: S
//    var lighterColor: Color
//    var darkerColor: Color
//    var size: CGFloat
//    
//    var body: some View {
//        ZStack {
//            if songViewModel.whiteLevel < 0.3 {
//                shape
//                    .fill(gradient(for: songViewModel.isPlaying))
//                    .shadow(color: Color.white.opacity(0.5), radius: 12, x: -5, y: -5)
//                    .shadow(color: Color.black.opacity(0.5), radius: 12, x: 5, y: 5)
//                    .blendMode(.overlay)
//                shape
//                    .fill(gradient(for: songViewModel.isPlaying))
//                    .overlay(shape.stroke(LinearGradient(direction: .diagonalTopToBottom, .blackGradient, .black), lineWidth: 2))
//            } else {
//                shape
//                    .fill(gradient(for: songViewModel.isPlaying))
//                    .shadow(color: Color.white.opacity(0.9), radius: 10, x: -5, y: -5)
//                    .shadow(color: Color.black.opacity(0.5), radius: 10, x: 5, y: 5)
//                    .blendMode(.overlay)
//                shape
//                    .fill(gradient(for: songViewModel.isPlaying))
//                    .overlay(shape.stroke(LinearGradient(direction: .diagonalTopToBottom, .blackGradient, .black), lineWidth: 2))
//            }
//        }
//        .frame(width: size, height: size)
//    }
//    private func gradient(for state: Bool) -> LinearGradient {
//        state ? LinearGradient(direction: .diagonalTopToBottom, songViewModel.darkerAccentColor, songViewModel.lighterAccentColor) : LinearGradient(direction: .diagonalTopToBottom, songViewModel.lighterAccentColor, songViewModel.darkerAccentColor)
//    }
//}

//struct ToggleButtonStyle: ToggleStyle {
//    @EnvironmentObject var songViewModel: NowPlayingViewModel
//    var musicController: MusicController
//    var size: CGFloat
//    var labelPadding: CGFloat
//
//    func makeBody(configuration: Self.Configuration) -> some View {
//        Button(action: {
//            songViewModel.isPlaying.toggle()
//            configuration.isOn = songViewModel.isPlaying ? true : false
//            configuration.isOn ? musicController.play() : musicController.pause()
//        }) {
//            configuration.label
//                .padding(labelPadding)
//                .contentShape(Circle())
//                .background(NeuToggleBackground(shape: Circle(), lighterColor: songViewModel.lighterAccentColor, darkerColor: songViewModel.darkerAccentColor, size: size))
//        }
//    }
//}

//struct NeuPlayPauseButton: View {
//    @EnvironmentObject var songViewModel: NowPlayingViewModel
//    @State var isPlaying: Bool
//    var musicController: MusicController
//    var symbolConfig: UIImage.SymbolConfiguration
//    var size: CGFloat
//    
//    var body: some View {
//        Toggle(isOn: $isPlaying) {
//            Image(systemName: songViewModel.isPlaying ? "pause": "play.fill")
//                .resizable()
//                .foregroundColor(Color(imageTint(isTooLight: songViewModel.isTooLight)))
//                .aspectRatio(contentMode: .fit)
//                .font(Font.system(.callout).weight(.black))
//                
//        }
//        .toggleStyle(ToggleButtonStyle(musicController: musicController, size: size, labelPadding: 30))
//    }
//    
//    func imageTint(isTooLight: Bool) -> UIColor {
//        isTooLight ? UIColor.black : UIColor.white
//    }
//    
//    private func gradient(for state: Bool) -> LinearGradient {
//        state ? LinearGradient(direction: .diagonalTopToBottom, songViewModel.darkerAccentColor, songViewModel.lighterAccentColor) : LinearGradient(direction: .diagonalTopToBottom, songViewModel.lighterAccentColor, songViewModel.darkerAccentColor)
//    }
//    
//    private func symbolForState() -> UIImage {
//        guard
//            let play = UIImage(systemName: "play.fill", withConfiguration: symbolConfig),
//            let pause = UIImage(systemName: "pause", withConfiguration: symbolConfig)
//        else { return UIImage() }
//        return isPlaying ? pause : play
//    }
//}

//struct NeuAlbumArtworkView<S: Shape>: View {
//    @EnvironmentObject var songViewModel: NowPlayingViewModel
//    @State var image: UIImage = UIImage()
//    var shape: S
//    var color1: Color
//    var color2: Color
//    var size: CGFloat
//    
//    var body: some View {
//        ZStack {
//            shape
//                .fill(LinearGradient(direction: .diagonalTopToBottom, color1, color2))
//                .overlay(
//                    shape
//                        .stroke(Color.black, lineWidth: 4)
//                        .blur(radius: 4)
//                        .offset(x: 10, y: 10)
//                        .mask(shape.fill(LinearGradient(direction: .diagonalTopToBottom, Color.clear, Color.black))))
//                .overlay(
//                    shape
//                        .stroke(Color.nowPlayingBG, lineWidth: 4)
//                        .blur(radius: 4)
//                        .offset(x: -10, y: -10)
//                        .mask(shape.fill(LinearGradient(direction: .diagonalTopToBottom, Color.black, Color.clear))))
//                .overlay(shape.stroke(LinearGradient(direction: .diagonalTopToBottom, .sysGraySix, .black), lineWidth: (size * 0.03)))
//                .shadow(color: Color.black.opacity(0.9), radius: 10, x: 5, y: 5)
//                .shadow(color: Color.white.opacity(0.1), radius: 10, x: -3, y: -3)
//            Image(uiImage: songViewModel.albumArtwork ?? UIImage())
//                .resizable()
//                .frame(width: size - (size * 0.03), height: size - (size * 0.03))
//                .scaledToFit()
//        }
//        .frame(width: size, height: size)
//    }
//}

//struct TrackProgressView: View {
//    
//    @EnvironmentObject var songViewModel: NowPlayingViewModel
//    var musicController: MusicController
//    @State var isDragging: Bool = false
//    var newPlaybackTime: TimeInterval = 0
//    
//    var dateFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "m:ss"
//        formatter.timeZone = TimeZone(secondsFromGMT: 0)
//        return formatter
//    }()
//    
//    var body: some View {
//        VStack {
//            ZStack {
//                GeometryReader { geo in
//                    HStack {
//                        RoundedRectangle(cornerRadius: 5)
//                            .fill(LinearGradient(gradient:
//                                Gradient(stops: [Gradient.Stop(color: .sysGrayFour, location: 0.2),
//                                                 Gradient.Stop(color: Color.black.opacity(0.75), location: 0.9)]),
//                                                 startPoint: .bottom,
//                                                 endPoint: .top))
//                            .frame(height: 8)
//                            .padding(.top, 3)
//                    }
//                }
//                GeometryReader { geo in
//                    HStack {
//                        RoundedRectangle(cornerRadius: 5)
//                            .fill(fillGradient(whiteLevel: songViewModel.whiteLevel))
//                            .frame(width: geo.size.width * self.percentagePlayedForSong(), height: 8)
//                            .overlay(RoundedRectangle(cornerRadius: 5)
//                                        .stroke(songViewModel.darkerAccentColor, lineWidth: 1))
//                            .padding(.top, 3)
//                        Spacer(minLength: 0)
//                    }
//                }
//                GeometryReader { geo in
//                    HStack {
//                        Circle()
//                            .fill(fillGradient(whiteLevel: songViewModel.whiteLevel))
//                            .frame(width: 14, height: 14)
//                            .animation(nil)
//                            .scaleEffect(isDragging ? 2 : 1)
//                            .padding(.leading, geo.size.width * self.percentagePlayedForSong() - 7)
//                            
//                            .gesture(
//                                DragGesture()
//                                    .onChanged({ value in
//                                        self.isDragging = true
//                                        songViewModel.timer?.invalidate()
//                                        songViewModel.timer = nil
//                                        self.songViewModel.elapsedTime = self.time(for: value.location.x, in: geo.size.width)
//                                            
//                                    })
//                                    .onEnded({ value in
//                                        self.isDragging = false
//                                        musicController.musicPlayer.currentPlaybackTime = self.time(for: value.location.x, in: geo.size.width)
//                                    })
//                            )
//                        Spacer(minLength: 0)
//                    }
//                }
//                HStack {
//                    Text(formattedTimeFor(timeInterval: songViewModel.elapsedTime))
//                        .font(Font.system(.headline).weight(.regular))
//                        .foregroundColor(.white)
//                    Spacer()
//                    Text(formattedTimeFor(timeInterval: songViewModel.duration))
//                        .font(Font.system(.headline).weight(.regular))
//                        .foregroundColor(.white)
//                }
//            }
//        }
//        .frame(width: UIScreen.main.bounds.width - 80, height: 80)
//        .padding(.top, 50)
//    }
//    
//    private func fillGradient(whiteLevel: CGFloat) -> LinearGradient {
//        if whiteLevel < 0.01 {
//            return LinearGradient(gradient: Gradient(colors: [songViewModel.darkerAccentColor, songViewModel.darkerAccentColor]), startPoint: .leading, endPoint: .trailing)
//        } else {
//            return LinearGradient(gradient: Gradient(colors: [songViewModel.lighterAccentColor, songViewModel.darkerAccentColor]), startPoint: .leading, endPoint: .trailing)
//        }
//    }
//    
//    func formattedTimeFor(timeInterval: TimeInterval) -> String {
//        let date = Date(timeIntervalSinceReferenceDate: timeInterval)
//        return dateFormatter.string(from: date)
//    }
//
//    func time(for location: CGFloat, in width: CGFloat) -> TimeInterval {
//        let percentage = location / width
//        let time = songViewModel.duration * TimeInterval(percentage)
//        if time < 0 {
//            return 0
//        } else if time > songViewModel.duration {
//            return songViewModel.duration
//        }
//        return time
//    }
//
//    func percentagePlayedForSong() -> CGFloat {
//        let percentagePlayed = CGFloat(songViewModel.elapsedTime / songViewModel.duration)
//        return percentagePlayed.isNaN ? 0.0 : percentagePlayed
//    }
//}

struct NowPlayingViewFull: View {
    let full = ViewControllerWrapper(viewController: NowPlayingViewController())
    var musicController: MusicController
    @EnvironmentObject var songViewModel: NowPlayingViewModel
    let topInset = UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.safeAreaInsets.top
    let namespace: Namespace.ID
    
    var body: some View {
        ZStack(alignment: .center) {
            LinearGradient(direction: .diagonalTopToBottom, .sysGraySix, .nowPlayingBG)
                .edgesIgnoringSafeArea(.all)
            VStack {
                HandleIndicator(width: UIScreen.main.bounds.width / 11, height: 6)
                    .matchedGeometryEffect(id: "HandleIndicator", in: namespace)

                    .padding(.bottom, 50)
                NeuAlbumArtworkView(shape: Rectangle(), size: 325)
                    .matchedGeometryEffect(id: "AlbumArtwork", in: namespace, properties: .frame, isSource: false)
                VStack {
                    Text(songViewModel.artist)
                        .font(Font.system(.title2).weight(.medium))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .matchedGeometryEffect(id: "Artist", in: namespace, properties: .frame, isSource: false)
                    Text(songViewModel.songTitle)
                        .font(Font.system(.headline).weight(.medium))
                        .foregroundColor(.lightTextColor)
                        .multilineTextAlignment(.center)
                        .matchedGeometryEffect(id: "SongTitle", in: namespace, properties: .frame, isSource: false)
                }
                .frame(minHeight: 60)
                .padding(.horizontal, 40)
                
                TrackProgressView(musicController: musicController)
                    .padding(.bottom, 12)
                HStack(spacing: 40) {
                    Spacer()
                    NeuTrackButton(size: 60, trackDirection: .trackBackward, musicController: musicController)
                        .matchedGeometryEffect(id: "TrackBackward", in: namespace, properties: .frame, isSource: true)
                    NeuPlayPauseButton(isPlaying: songViewModel.isPlaying, musicController: musicController, labelPadding: 30, size: 90, namespace: namespace)
                        .frame(width: 90, height: 90)
                        .matchedGeometryEffect(id: "PlayButton", in: namespace, properties: .frame, isSource: true)
                    NeuTrackButton(size: 60, trackDirection: .trackForward, musicController: musicController)
                        .matchedGeometryEffect(id: "TrackForward", in: namespace, properties: .frame, isSource: true)
                    Spacer()
                }
            }
//            .padding(.top, (topInset ?? 20) + 20)
        }
//        .transition(.move(edge: .bottom))
//        .cornerRadius(12)
    }
}



struct BottomSheet<SheetContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let sheetContent: () -> SheetContent
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isPresented {
                VStack {
                    Spacer()
                    VStack {
                        HStack {
                            Spacer()
                        }
                        sheetContent()
                    }
                    .padding()
                }
                .zIndex(.infinity)
                .transition(.move(edge: .bottom))
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}


struct NowPlayingView_Previews: PreviewProvider {
    static var previews: some View {
        let musicController = MusicController()
        NowPlayingView(musicController: musicController, delegate: NowPlayingBarViewController(), isFullScreen: musicController.nowPlayingViewModel.isFullScreen, height: UIScreen.main.bounds.height - 120, tabBarHeight: 50).environmentObject(musicController.nowPlayingViewModel)
    }
}
