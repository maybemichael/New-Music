//
//  TransitionPractice.swift
//  New-Music
//
//  Created by Michael McGrath on 10/26/20.
//

import SwiftUI

struct TransitionPractice: View {
    var practiceSongs = [PracticeSong(songTitle: "Hold you down", artist: "DJ Khalid"),
                         PracticeSong(songTitle: "Hold you down", artist: "DJ Khalid"),
                         PracticeSong(songTitle: "Hold you down", artist: "DJ Khalid"),
                         PracticeSong(songTitle: "Hold you down", artist: "DJ Khalid")]
    var musicController: MusicController
    @EnvironmentObject var songViewModel: NowPlayingViewModel
    @GestureState private var dragState = DragState.inactive
    @State var position: CGFloat = 0
//    @State var isFullScreen: Bool = false
    @State var bottomAnchor = UIScreen.main.bounds.height
    @State var topAnchor: CGFloat = 0
    @State var cardBottomEdgeLocation: CGFloat = UIScreen.main.bounds.height
    @Namespace var namespace
    @State var isFull: Bool = false
    var delegate: TabBarStatus
    let topInset = UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.safeAreaInsets.top
    let bottomInset = UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.safeAreaInsets.bottom
    let height: CGFloat
    let tabBarHeight: CGFloat
    var drag: some Gesture {
        let drag = DragGesture()
            .updating($dragState) { drag, state, transaction in
                state = .dragging(translation: drag.translation)
                isFull = false 
                
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
//                NowPlayingPracticeBar(isFull: songViewModel.isFullScreen, namespace: namespace, musicController: musicController, isFullScreen: <#Binding<Bool>#>)
//                    .frame(width: UIScreen.main.bounds.width, height: 100, alignment: .bottom)
//                    .onTapGesture {
//                        withAnimation(Animation.easeOut(duration: 0.3)) {
//                            isFull = true
//                        }
//                    }
            }
            .padding(.vertical, tabBarHeight)
        }
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
                delegate.toggleHidden(isFullScreen: songViewModel.isFullScreen)
                self.position = CardPosition.bottom.offset
            }
        } else {
            withAnimation {
                songViewModel.isFullScreen = true
                delegate.toggleHidden(isFullScreen: songViewModel.isFullScreen)
                self.position = CardPosition.top.offset
            }
        }
    }
}

struct TransitionPractice_Previews: PreviewProvider {
    static var previews: some View {
        let musicController = MusicController()
        TransitionPractice(musicController: musicController, delegate: NowPlayingBarViewController(), height: UIScreen.main.bounds.height, tabBarHeight: 50).environmentObject(musicController.nowPlayingViewModel)
    }
}
