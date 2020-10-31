//
//  NowPlayingFullView.swift
//  New-Music
//
//  Created by Michael McGrath on 10/26/20.
//

import SwiftUI

struct NowPlayingFullView: View {
    @EnvironmentObject var nowPlayingViewModel: NowPlayingViewModel
    @GestureState private var dragState = DragState.inactive
    @State private var position: CGFloat = 0
    @State private var topAnchor: CGFloat = 0
    @Binding var isPresented: Bool
    let musicController: MusicController
    @Namespace var namespace
//    let namespace: Namespace.ID?
    
    var drag: some Gesture {
        let drag = DragGesture()
            .updating($dragState) { drag, state, transaction in
                state = .dragging(translation: drag.translation)

            }
            .onEnded(onDragEnded)
        return drag
    }
    
    var body: some View {
            VStack {
                AlbumArtworkView(namespace: namespace)
                    .padding(.bottom, 20)
                VStack {
                    Text(nowPlayingViewModel.songTitle)
                        .font(Font.system(.title2).weight(.medium))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    Text(nowPlayingViewModel.artist)
                        .font(Font.system(.headline).weight(.medium))
                        .foregroundColor(.lightTextColor)
                        .multilineTextAlignment(.center)
                    
                }
                .frame(minHeight: 80, alignment: .top)
                .padding(.horizontal, 40)
                TrackProgressBarView(musicController: musicController)
                HStack(spacing: 40) {
                    NeuTrackButton(size: UIScreen.main.bounds.width / 7, trackDirection: .trackBackward, musicController: musicController)
                    NeuPlayPauseButton(isPlaying: nowPlayingViewModel.isPlaying, musicController: musicController, labelPadding: 30, size: UIScreen.main.bounds.width / 4.7, namespace: namespace)
                        .frame(width: UIScreen.main.bounds.width / 4.7, height: UIScreen.main.bounds.width / 4.7, alignment: .center)
                    NeuTrackButton(size: UIScreen.main.bounds.width / 7, trackDirection: .trackForward, musicController: musicController)
                }
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .background(LinearGradient(direction: .diagonalTopToBottom, .sysGraySix, .nowPlayingBG))
            .edgesIgnoringSafeArea(.all)
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


struct NowPlayingFullView_Previews: PreviewProvider {
    static var previews: some View {
        let musicController = MusicController()
        let namespace = Namespace()
        NowPlayingFullView(isPresented: .constant(true), musicController: musicController).environmentObject(musicController.nowPlayingViewModel)
    }
}
