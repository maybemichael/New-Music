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
            Color.clear
                .edgesIgnoringSafeArea(.all)
            VStack {
                AlbumArtworkView()
                    .padding(.bottom, 20)
                    .scaleEffect(nowPlayingViewModel.isPlaying ? 1.0 : 0.77)
                    .animation(.easeOut(duration: 0.3))
                VStack {
                    Text(nowPlayingViewModel.artist)
//                    Text("Fall Out Boy")
                        .font(Font.system(.title3).weight(.medium))
                        .foregroundColor(nowPlayingViewModel.textColor2)
                        .multilineTextAlignment(.center)
                    Text(nowPlayingViewModel.songTitle)
//                    Text("Grand Theft Autumn")
                        .font(Font.system(.title2).weight(.medium))
                        .foregroundColor(textColorFor(isTooLight: nowPlayingViewModel.isTooLight))
                        .multilineTextAlignment(.center)
                    
                }
                .frame(minHeight: 80, alignment: .center)
                .padding(.horizontal, 40)
                TrackProgressBarView(musicController: musicController)
                HStack(spacing: 40) {
                    NeuTrackButton(size: UIScreen.main.bounds.width / 7, trackDirection: .trackBackward, musicController: musicController)
                    NeuPlayPauseButton(isPlaying: nowPlayingViewModel.isPlaying, musicController: musicController, labelPadding: 30, size: UIScreen.main.bounds.width / 4.7)
                        .frame(width: UIScreen.main.bounds.width / 4.7, height: UIScreen.main.bounds.width / 4.7, alignment: .center)
                    NeuTrackButton(size: UIScreen.main.bounds.width / 7, trackDirection: .trackForward, musicController: musicController)
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(nowPlayingViewModel.lighterAccentColor.opacity(opacity(for: nowPlayingViewModel.whiteLevel)))
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
    
    private func opacity(for whiteLevel: CGFloat) -> Double {
        switch whiteLevel {
        case 0...0.3:
            return 0.7
        case 0.31...7:
            return 0.25
        case 0.71...1:
            return 0.1
        default:
            return 0.35
        }
    }
    
    private func textColorFor(isTooLight: Bool) -> Color {
        isTooLight ? Color.black : Color.white
    }
    
    private func backgroundColorFor(isTooLight: Bool) -> Color {
        isTooLight ? nowPlayingViewModel.darkerAccentColor : nowPlayingViewModel.lighterAccentColor
    }
}


struct NowPlayingFullView_Previews: PreviewProvider {
    static var previews: some View {
        let musicController = MusicController()
        NowPlayingFullView(isPresented: .constant(true), musicController: musicController).environmentObject(musicController.nowPlayingViewModel)
    }
}