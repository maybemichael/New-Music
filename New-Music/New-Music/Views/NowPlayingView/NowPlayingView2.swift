//
//  NowPlayingView2.swift
//  New-Music
//
//  Created by Michael McGrath on 10/27/20.
//

import SwiftUI

struct NowPlayingView2: View {
    @EnvironmentObject private var nowPlayingViewModel: NowPlayingViewModel
    @Namespace var namespace
    @GestureState private var dragState = DragState.inactive
    @State private var position: CGFloat = 10
    @State private var topAnchor: CGFloat = 10
    var musicController: MusicController
    var tabBarHeight: CGFloat
//    var safeAreaHeight: CGFloat
    @State var justToBuild = false
    
    var drag: some Gesture {
        let drag = DragGesture()
            .updating($dragState) { drag, state, transaction in
                state = .dragging(translation: drag.translation)
            }
            .onEnded(onDragEnded)
        return drag
    }
    
    
    var body: some View {
        ZStack(alignment: .center) {
            Color.nowPlayingBG
                .edgesIgnoringSafeArea(.all)
            HandleIndicator(width: UIScreen.main.bounds.width / 11, height: 6)
                .matchedGeometryEffect(id: "HandleIndicator", in: namespace)
            VStack {
                List {
                    ForEach(nowPlayingViewModel.songs) { song in
                        PlaylistSongView(songTitle: song.songName, artist: song.artistName, albumArtwork: song.albumArtwork ?? Data())
                    }.listRowBackground(Color.nowPlayingBG)
                }
                .frame(width: UIScreen.main.bounds.width, height: getPlaylistHeight(), alignment: .center)
                .onAppear {
                    UITableView.appearance().separatorStyle = .singleLine
                    UITableView.appearance().backgroundColor = UIColor.backgroundColor
                    UITableView.appearance().separatorColor = UIColor.white
                    UITableViewCell.appearance().contentView.backgroundColor = UIColor.backgroundColor
                    UITableViewCell.appearance().backgroundColor = UIColor.backgroundColor
                }
                ZStack(alignment: .center) {
                    Color.clear
                        .blur(radius: 10.0)
                        .edgesIgnoringSafeArea(.all)
//                    NowPlayingBarView(musicController: musicController, namespace: namespace, isPresented: $justToBuild, fullScreenDelegate: fullScreenDelegate)
                        .offset(.init(width: 0, height: -10))
                    
                }
                .background(Color.nowPlayingBG.opacity(0.05))
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 10, alignment: .center)
                .background(Color.nowPlayingBG.opacity(0.05))
                .matchedGeometryEffect(id: "NowPlayingView", in: namespace, properties: .frame, isSource: true)
            }
            
//            if nowPlayingViewModel.isFullScreen {
//                ZStack(alignment: .top) {
//                    VStack {
//                        NowPlayingFullView(isPresented: $justToBuild, musicController: musicController, namespace: namespace)
//                            .background(LinearGradient(direction: .diagonalTopToBottom, .sysGraySix, .nowPlayingBG))
//                            .cornerRadius(20.0)
//                            .offset(y: setOffset())
//                            .animation(self.dragState.isDragging ? nil : .interpolatingSpring(stiffness: 400.0, damping: 50.0, initialVelocity: 7))
//                            .gesture(drag)
//                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .bottom)
//                        
//                    }
//                }
//                .matchedGeometryEffect(id: "NowPlayingView", in: namespace, properties: .frame, isSource: false)
//            }
        }
        .background(Color.nowPlayingBG)
        .edgesIgnoringSafeArea(.all)
    }
    
    private func setOffset() -> CGFloat {
        return self.position + self.dragState.translation.height
    }
    
    private func onDragEnded(drag: DragGesture.Value) {
        let verticalDirection = drag.predictedEndLocation.y - drag.location.y
        topAnchor = self.position + drag.translation.height
        let positionAbove: CGFloat = CardPosition.top.offset
        let positionBelow: CGFloat = CardPosition.bottom.offset
        let closestPosition: CGFloat
        
        if verticalDirection > 40 {
            withAnimation(Animation.easeIn) {
                nowPlayingViewModel.isFullScreen = false
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
            withAnimation(Animation.easeIn) {
                nowPlayingViewModel.isFullScreen = false
                self.position = CardPosition.bottom.offset
            }
        } else {
            withAnimation(Animation.easeOut) {
                nowPlayingViewModel.isFullScreen = true
                self.position = CardPosition.top.offset
            }
        }
    }
    
    private func getPlaylistHeight() -> CGFloat {
        nowPlayingViewModel.isFullScreen ? (UIScreen.main.bounds.height - 225) + (UIScreen.main.bounds.height / 10) : UIScreen.main.bounds.height - 225
    }
}

struct NowPlayingView2_Previews: PreviewProvider {
    static var previews: some View {
        let musicController = MusicController()
        NowPlayingView2(musicController: musicController, tabBarHeight: 60).environmentObject(musicController.nowPlayingViewModel)
    }
}
