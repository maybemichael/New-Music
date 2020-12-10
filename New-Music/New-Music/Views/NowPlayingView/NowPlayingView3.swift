//
//  NowPlayingView3.swift
//  New-Music
//
//  Created by Michael McGrath on 10/29/20.
//

import SwiftUI

struct NowPlayingView3: View {
    @EnvironmentObject private var nowPlayingViewModel: NowPlayingViewModel
    @Namespace var namespace
    let musicController: MusicController
    @State var isPresented = false
    @GestureState private var dragState = DragState.inactive
    @State private var position: CGFloat = 0
    @State private var topAnchor: CGFloat = 0
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
                .edgesIgnoringSafeArea(.all)
            VStack {
                List {
                    ForEach(nowPlayingViewModel.songs) { song in
                        PlaylistSongView(songTitle: song.songName, artist: song.artistName, albumArtwork: song.albumArtwork ?? Data())
                    }.listRowBackground(Color.nowPlayingBG)
                }
                .frame(alignment: .top)
                .onAppear {
                    UITableView.appearance().separatorStyle = .singleLine
                    UITableView.appearance().backgroundColor = UIColor.backgroundColor
                    UITableView.appearance().separatorColor = UIColor.white
                    UITableViewCell.appearance().contentView.backgroundColor = UIColor.backgroundColor
                    UITableViewCell.appearance().backgroundColor = UIColor.backgroundColor
                }
                if !isPresented {
                    NowPlayingBarView(musicController: musicController)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 11, alignment: .center)
                        .background(Color.nowPlayingBG)
                        .onTapGesture {
                            withAnimation(.easeOut(duration: 0.3)) {
                                isPresented = true
                            }
                        }
                }
            }
            .frame(alignment: .top)
            ZStack {
                if isPresented {
                    NowPlayingFullView(frame: CGRect(x: 40, y: UIScreen.main.bounds.height / 6, width: UIScreen.main.bounds.width - 80, height: UIScreen.main.bounds.width - 80), musicController: musicController, frameDelegate: NowPlayingFullViewController())
                        .background(LinearGradient(direction: .diagonalTopToBottom, .sysGraySix, .nowPlayingBG))
                        .cornerRadius(20)
                        .edgesIgnoringSafeArea(.all)
//                        .transition(.move(edge: .bottom))
                        .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .offset(x: 0, y: (UIScreen.main.bounds.height / 11) * 9)))
                        .animation(.easeOut(duration: 0.3))
//                        .transition(.move(edge: .bottom))
//                        .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .offset(x: 0, y: UIScreen.main.bounds.height / 1.8)))
                }
                
            }
            .offset(y: setOffset())
            .animation(self.dragState.isDragging ? nil : .interpolatingSpring(stiffness: 400.0, damping: 50.0, initialVelocity: 7))
            .gesture(drag)
            .zIndex(1.0)
        }
    }

    
    private func getTopInset() -> CGFloat {
        guard let topInset = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first?.safeAreaInsets.top else { return 30 }
        return topInset + 10
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
        if (topAnchor - positionAbove) < (positionBelow - topAnchor) {
            closestPosition = positionAbove
        } else {
            closestPosition = positionBelow
        }
        if closestPosition == positionBelow {
            isPresented = false
        }
        if verticalDirection > 30 {
//            self.position = closestPosition
//            withAnimation(.easeIn(duration: 0.05)) {
                isPresented = false
                
//            }
        } else if verticalDirection < 0 {
            withAnimation(.linear(duration: 0.2)) {
                isPresented = true
//                self.position = closestPosition
            }
        }
    }
    
    private func heightForState() -> CGFloat {
        isPresented ? UIScreen.main.bounds.height : UIScreen.main.bounds.height / 11
    }
    
    private func getPlaylistHeight() -> CGFloat {
        nowPlayingViewModel.isFullScreen ? (UIScreen.main.bounds.height - 225) + (UIScreen.main.bounds.height / 10) : UIScreen.main.bounds.height - 225
    }
}

struct NowPlayingView3_Previews: PreviewProvider {
    static var previews: some View {
        let musicController = MusicController()
        
        NowPlayingView3(musicController: musicController, tabBarHeight: 0).environmentObject(musicController.nowPlayingViewModel)
    }
}
