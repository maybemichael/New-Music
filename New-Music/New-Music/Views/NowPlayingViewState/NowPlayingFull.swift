//
//  NowPlayingFull.swift
//  New-Music
//
//  Created by Michael McGrath on 10/24/20.
//

import SwiftUI

struct NowPlayingFull: View {
    var musicController: MusicController
    @EnvironmentObject var songViewModel: NowPlayingViewModel
    let topInset = UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.safeAreaInsets.top
    let namespace: Namespace.ID
    @Binding var isPresented: Bool
    @GestureState private var dragState = DragState.inactive
    @State private var position: CGFloat = 0
    @State private var topAnchor: CGFloat = 0
    
    var drag: some Gesture {
        let drag = DragGesture()
            .updating($dragState) { drag, state, transaction in
                state = .dragging(translation: drag.translation)

            }
            .onEnded(onDragEnded)
        return drag
    }
    
    var body: some View {
        ZStack {
            Color.nowPlayingBG
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                HandleIndicator(width: UIScreen.main.bounds.width / 11, height: 6)
                    .frame(alignment: .top)
                    .matchedGeometryEffect(id: "HandleIndicator", in: namespace)
                NeuAlbumArtworkView(shape: Rectangle(), size: 325)
                    .matchedGeometryEffect(id: "AlbumArtwork", in: namespace, properties: .frame, isSource: false)
                VStack {
                    Text(songViewModel.songTitle)
                        .font(Font.system(.title3).weight(.light))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .matchedGeometryEffect(id: "Artist", in: namespace, properties: .frame, isSource: false)
                    Text(songViewModel.artist)
                        .font(Font.system(.headline).weight(.semibold))
                        .foregroundColor(.lightTextColor)
                        .multilineTextAlignment(.center)
                        .matchedGeometryEffect(id: "SongTitle", in: namespace, properties: .frame, isSource: false)
                }
                //            .frame(minHeight: 60)
                .padding(.horizontal, 40)
                TrackProgressView(musicController: musicController)
                //                .padding(.bottom, 12)
                HStack(spacing: 40) {
                    NeuTrackButton(size: 60, trackDirection: .trackBackward, musicController: musicController)
                        .matchedGeometryEffect(id: "TrackBackward", in: namespace, properties: .frame, isSource: true)
                    NeuPlayPauseButton(isPlaying: songViewModel.isPlaying, musicController: musicController, labelPadding: 30, size: 90, namespace: namespace)
                        .frame(width: 90, height: 90)
                        .matchedGeometryEffect(id: "PlayButton", in: namespace, properties: .frame, isSource: true)
                    NeuTrackButton(size: 60, trackDirection: .trackForward, musicController: musicController)
                        .matchedGeometryEffect(id: "TrackForward", in: namespace, properties: .frame, isSource: true)
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//        .background(LinearGradient(direction: .diagonalTopToBottom, .sysGraySix, .nowPlayingBG))
//        .edgesIgnoringSafeArea(.all)
        .transition(.move(edge: .bottom))
        .offset(y: setOffset())
        .animation(self.dragState.isDragging ? nil : .interpolatingSpring(stiffness: 400.0, damping: 50.0, initialVelocity: 7))
        .gesture(drag)
        .padding(.bottom, topInset)

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
        if verticalDirection > 40 {
            withAnimation(Animation.easeIn(duration: 0.3)) {
                position = CardPosition.top.offset
                isPresented = false
            }
        }
        if (topAnchor - positionAbove) < (positionBelow - topAnchor) {
            closestPosition = positionAbove
        } else {
            closestPosition = positionBelow
        }

        if verticalDirection > 0 {
            withAnimation(Animation.easeOut(duration: 0.3)) {
//                self.viewControllerHolder?.dismiss(animated: true, completion: nil)
                isPresented = false
                self.position = positionBelow
            }
        } else if verticalDirection < 0 {
            withAnimation(Animation.easeOut(duration: 0.3)) {
                isPresented = true
                self.position = positionAbove
            }
        } else {
            self.position = closestPosition
        }
    }
}

struct NowPlayingFull_Previews: PreviewProvider {
    static var previews: some View {
        let musicController = MusicController()
        NowPlayingFull(musicController: musicController, namespace: Namespace().wrappedValue, isPresented: .constant(true)).environmentObject(musicController.nowPlayingViewModel)
    }
}
