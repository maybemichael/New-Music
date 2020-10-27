//
//  NowPlayingPracticeView.swift
//  New-Music
//
//  Created by Michael McGrath on 10/25/20.
//

import SwiftUI

struct PracticeSong: Identifiable {
    var id: UUID = UUID()
    var songTitle: String
    var artist: String
    var image: UIImage = UIImage(named: "Nirvana") ?? UIImage()
}

struct NowPlayingPracticeView: View {
    var practiceSongs = [PracticeSong(songTitle: "Hold you down", artist: "DJ Khalid"),
                         PracticeSong(songTitle: "Hold you down", artist: "DJ Khalid"),
                         PracticeSong(songTitle: "Hold you down", artist: "DJ Khalid"),
                         PracticeSong(songTitle: "Hold you down", artist: "DJ Khalid")]
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
    var coordinator: MainCoordinator?
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
        ZStack(alignment: .bottom) {
            Color.nowPlayingBG
            VStack {
                List {
                    ForEach(practiceSongs) { song in
                        PlaylistSongPracticeView(songTitle: song.songTitle, artist: song.artist, image: song.image)
                    }.listRowBackground(Color.nowPlayingBG)
                }
                .frame(width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height / 9) * 6, alignment: .leading)
                .padding(.bottom, tabBarHeight)
            }
            .padding(.vertical, tabBarHeight)
            NowPlayingPracticeBar(isFullScreen: $isFullScreen, namespace: namespace, musicController: musicController)
                .offset(y: setOffset())
                .animation(self.dragState.isDragging ? nil : .interpolatingSpring(stiffness: 400.0, damping: 50.0, initialVelocity: 7))
                .gesture(drag)
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .bottom)
        .background(Color.nowPlayingBG)
        .transition(.move(edge: .top))
    }
    
    func setOffset() -> CGFloat {
        return self.position + self.dragState.translation.height
    }
    
    private func onDragEnded(drag: DragGesture.Value) {
        let verticalDirection = drag.predictedEndLocation.y - drag.location.y
        topAnchor = self.position + drag.translation.height
        cardBottomEdgeLocation = self.bottomAnchor + drag.translation.height
        let positionAbove: CGFloat = CardPosition.top.offset
        let positionBelow: CGFloat = CardPosition.bottom.offset
        let closestPosition: CGFloat
        
//        if verticalDirection > 40 {
            withAnimation(Animation.easeOut(duration: 0.2)) {
                isFullScreen = false
                self.position = CardPosition.bottom.offset
            }
//        }
        
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
                isFullScreen = false
                delegate.toggleHidden(isFullScreen: songViewModel.isFullScreen)
                self.position = CardPosition.bottom.offset
            }
        }
        else {
            withAnimation {
                isFullScreen = true
                delegate.toggleHidden(isFullScreen: songViewModel.isFullScreen)
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
    
    init(musicController: MusicController, delegate: TabBarStatus, isFullScreen: Bool, height: CGFloat, tabBarHeight: CGFloat, fullScreen: Bool, coordinator: MainCoordinator?) {
        self.musicController = musicController
        self.delegate = delegate
        //        self.isFullScreen = false
        self.height = height
        self.tabBarHeight = tabBarHeight
        //        self.isFullScreen = fullScreen
        self.coordinator = coordinator
        self.isFullScreen = isFullScreen
        UITableView.appearance().separatorStyle = .singleLine
        UITableView.appearance().backgroundColor = UIColor.backgroundColor
        UITableView.appearance().separatorColor = UIColor.white
        UITableViewCell.appearance().contentView.backgroundColor = UIColor.backgroundColor
        UITableViewCell.appearance().backgroundColor = UIColor.backgroundColor
    }
}

struct NowPlayingPracticeView_Previews: PreviewProvider {
    static var previews: some View {
        let musicController = MusicController()
        NowPlayingPracticeView(musicController: musicController, delegate: NowPlayingBarViewController(), isFullScreen: musicController.nowPlayingViewModel.isFullScreen, height: UIScreen.main.bounds.height, tabBarHeight: 50, fullScreen: musicController.nowPlayingViewModel.isFullScreen, coordinator: nil).environmentObject(musicController.nowPlayingViewModel)
    }
}

struct NowPlayingPracticeBar: View {
    @EnvironmentObject var songViewModel: NowPlayingViewModel
    @GestureState private var dragState = DragState.inactive
    @State var position: CGFloat = 0
    @State var bottomAnchor = UIScreen.main.bounds.height
    @State var topAnchor: CGFloat = 0
    @Binding var isFullScreen: Bool
    let namespace: Namespace.ID
    var coordinator: MainCoordinator?
    var musicController: MusicController
    let full = ViewControllerWrapper(viewController: NowPlayingViewController())
    
    var drag: some Gesture {
        let drag = DragGesture()
            .updating($dragState) { drag, state, transaction in
                state = .dragging(translation: drag.translation)
                
                
            }
            .onEnded(onDragEnded)
        return drag
    }
    
    var body: some View {
        
        if isFullScreen {
//            full
//                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
//                .background(Color.nowPlayingBG)
            VStack {
                NeuAlbumArtworkView(shape: Rectangle(), size: UIScreen.main.bounds.width - 80)
                Text("DJ Khalid")
                    .font(Font.system(.title2).weight(.medium))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .matchedGeometryEffect(id: "Artist", in: namespace, properties: .frame, isSource: false)
                Text("Hold you down")
                    .font(Font.system(.headline).weight(.medium))
                    .foregroundColor(.lightTextColor)
                    .multilineTextAlignment(.center)
                    .matchedGeometryEffect(id: "SongTitle", in: namespace, properties: .frame, isSource: false)
                TrackProgressView(musicController: musicController)
                HStack(spacing: 40) {
                    Spacer()
                    TrackButton(size: 60, trackDirection: .trackBackward, musicController: musicController)
                        .matchedGeometryEffect(id: "TrackBackward", in: namespace, properties: .frame, isSource: true)
                    NeuPlayPauseButton(isPlaying: songViewModel.isPlaying, musicController: musicController, labelPadding: 40, size: 90)
                        .frame(width: 90, height: 90)
                        .matchedGeometryEffect(id: "PlayButton", in: namespace, properties: .frame, isSource: true)
                    TrackButton(size: 60, trackDirection: .trackForward, musicController: musicController)
                        .matchedGeometryEffect(id: "TrackForward", in: namespace, properties: .frame, isSource: true)
                    Spacer()
                }
            }
//            .offset(y: setOffset())
//            .animation(self.dragState.isDragging ? nil : .interpolatingSpring(stiffness: 400.0, damping: 50.0, initialVelocity: 7))
//            .gesture(drag)
            .frame(width: UIScreen.main.bounds.width, height: heightForState())
            .background(Color.nowPlayingBG)
//            .transition(.move(edge: .bottom))
        }
        if !isFullScreen {
            HStack {
                ZStack {
                    Rectangle()
                        .background(Color.nowPlayingBG)
                        .frame(width: UIScreen.main.bounds.width / 6, height: UIScreen.main.bounds.width / 6, alignment: .bottom)
                    Image("Nirvana")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width / 6 - (UIScreen.main.bounds.width / 6 * 0.07), height: UIScreen.main.bounds.width / 6 - (UIScreen.main.bounds.width / 6 * 0.07))
                }
                VStack {
                    Text("Hold you down")
                        .font(Font.system(.headline).weight(.light))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    Text("DJ Khalid")
                        .font(Font.system(.subheadline).weight(.light))
                        .foregroundColor(.lightTextColor)
                        .lineLimit(1)
                }
                BarPlayButton(isPlaying: musicController.nowPlayingViewModel.isPlaying, musicController: musicController, size: UIScreen.main.bounds.width / 6.5, symbolConfig: .barPlayButton)
                BarTrackButton(imageName: "forward.fill", size: UIScreen.main.bounds.width / 8, trackDirection: .trackForward, musicController: musicController)
            }
            .frame(width: UIScreen.main.bounds.width, height: heightForState())
            .background(Color.nowPlayingBG)
            .transition(.move(edge: .bottom))
            .onTapGesture {
                withAnimation(Animation.easeOut(duration: 0.3)) {
//                    songViewModel.isFullScreen = true
                    self.position = CardPosition.top.offset
                    isFullScreen = true
//                    self.coordinator?.presentFullScreenNowPlaying(fromVC: nil)
                }
            }
        }
    }
    
    private func heightForState() -> CGFloat {
        songViewModel.isFullScreen ? UIScreen.main.bounds.height : UIScreen.main.bounds.height / 11
    }
    
    private func onDragEnded(drag: DragGesture.Value) {
        let verticalDirection = drag.predictedEndLocation.y - drag.location.y
        topAnchor = self.position + drag.translation.height
//        cardBottomEdgeLocation = self.bottomAnchor + drag.translation.height
        let positionAbove: CGFloat = CardPosition.top.offset
        let positionBelow: CGFloat = CardPosition.bottom.offset
        let closestPosition: CGFloat
        
//        if verticalDirection > 40 {
        withAnimation(Animation.easeOut) {
            songViewModel.isFullScreen = true
//                songViewModel.isFullScreen = true
            }
//        }
        
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
//                songViewModel.isFullScreen = false
                songViewModel.isFullScreen = false
//                delegate.toggleHidden(isFullScreen: songViewModel.isFullScreen)
                self.position = CardPosition.bottom.offset
            }
        } else {
            withAnimation {
//                songViewModel.isFullScreen = true
                songViewModel.isFullScreen = true
//                delegate.toggleHidden(isFullScreen: songViewModel.isFullScreen)
                self.position = CardPosition.top.offset
                    
            }
        }
    }
    
    func setOffset() -> CGFloat {
//        if self.topAnchor < 0 {
//            return 0
//        }
//        if self.cardBottomEdgeLocation < UIScreen.main.bounds.height {
//            return UIScreen.main.bounds.height
//        }
        return self.position + self.dragState.translation.height
    }
}



struct PlaylistSongPracticeView: View {
    
    var songTitle: String
    var artist: String
    var image: UIImage
    
    var body: some View {
        HStack {
            ZStack {
                Rectangle()
                    .background(Color.nowPlayingBG)
                    .frame(width: UIScreen.main.bounds.width / 6, height: UIScreen.main.bounds.width / 6, alignment: .center)
                Image("Nirvana")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width / 6 - (UIScreen.main.bounds.width / 6 * 0.07), height: UIScreen.main.bounds.width / 6 - (UIScreen.main.bounds.width / 6 * 0.07))
            }
            VStack {
                Text("Hold you down")
                    .font(Font.system(.headline).weight(.light))
                    .foregroundColor(.white)
                    .lineLimit(1)
                Text("DJ Khalid")
                    .font(Font.system(.subheadline).weight(.light))
                    .foregroundColor(.lightTextColor)
                    .lineLimit(1)
            }
        }
    }
}

//struct NowPlayingPracticeBarView_Previews: PreviewProvider {
//    static var previews: some View {
//        let musicController = MusicController()
//        let namespace = Namespace()
//        NowPlayingPracticeBar(isFull: musicController.nowPlayingViewModel.isFullScreen, namespace: namespace.wrappedValue, musicController: musicController, isFullScreen: <#Binding<Bool>#>).environmentObject(musicController.nowPlayingViewModel)
//    }
//}
