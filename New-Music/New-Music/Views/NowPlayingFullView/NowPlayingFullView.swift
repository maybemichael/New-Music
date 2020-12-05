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
            if nowPlayingViewModel.isFullScreen {
                VStack {
                    GeometryReader { geo in
                        AlbumArtworkView()
                            //                    Rectangle()
                            //                        .foregroundColor(.clear)
                            //                        .padding(.bottom, 20)
                            .foregroundColor(.clear)
                            .padding(.bottom, 20)
                            .onAppear {
                                nowPlayingViewModel.fullImageFrame = CGRect(x: 0, y: geo.frame(in: .named("FullNowPlayingView")).minY + UIScreen.main.bounds.height, width: geo.frame(in: .named("FullNowPlayingView")).width, height: geo.frame(in: .named("FullNowPlayingView")).height)
                                print("Albunm Artwork Full Frame: \(geo.frame(in: .named("FullNowPlayingView")))")
                            }
                            .onChange(of: nowPlayingViewModel.isFullScreen, perform: { value in
                                if !nowPlayingViewModel.isFullScreen {
                                    nowPlayingViewModel.fullImageFrame = geo.frame(in: .global)
                                    print("On Changed Album Artwork Frame: \(nowPlayingViewModel.fullImageFrame)")
                                }
                            })
                    }
                    .frame(width: UIScreen.main.bounds.width - 80, height: UIScreen.main.bounds.width - 80)
                    VStack {
                        Text(nowPlayingViewModel.artist)
                            //                    Text("Fall Out Boy")
                            .font(Font.system(.title3).weight(.medium))
                            .foregroundColor(nowPlayingViewModel.textColor2)
                            .multilineTextAlignment(.center)
                        Text(nowPlayingViewModel.songTitle)
                            //                    Text("Grand Theft Autumn")
                            .font(Font.system(.title3).weight(.medium))
                            .foregroundColor(textColorFor(isTooLight: nowPlayingViewModel.isTooLight))
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                        
                    }
                    .frame(minHeight: 80, alignment: .center)
                    .padding(.horizontal, 40)
                    TrackProgressBarView(musicController: musicController)
                    HStack(spacing: 40) {
                        NeuTrackButton(size: UIScreen.main.bounds.width / 7, trackDirection: .trackBackward, musicController: musicController)
                            .frame(width: UIScreen.main.bounds.width / 7, height: UIScreen.main.bounds.width / 7, alignment: .center)
                        NeuPlayPauseButton(isPlaying: nowPlayingViewModel.isPlaying, musicController: musicController, labelPadding: 30, size: UIScreen.main.bounds.width / 4.7)
                            .frame(width: UIScreen.main.bounds.width / 4.7, height: UIScreen.main.bounds.width / 4.7, alignment: .center)
                        NeuTrackButton(size: UIScreen.main.bounds.width / 7, trackDirection: .trackForward, musicController: musicController)
                            .frame(width: UIScreen.main.bounds.width / 7, height: UIScreen.main.bounds.width / 7, alignment: .center)
                    }
                }
            }
            //        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            
            
        }
        .background(nowPlayingStateBackground(isFullScreen: nowPlayingViewModel.isFullScreen).animation(.linear(duration: 0.4)))
        //        .background(backgroundColorFor(isTooLight: nowPlayingViewModel.isTooLight))
        .coordinateSpace(name: "FullNowPlayingView")
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
            }
        }
        if (topAnchor - positionAbove) < (positionBelow - topAnchor) {
            closestPosition = positionAbove
        } else {
            closestPosition = positionBelow
        }

        if verticalDirection > 0 {
            withAnimation(Animation.easeOut(duration: 0.3)) {
                self.position = positionBelow
            }
        } else if verticalDirection < 0 {
            withAnimation(Animation.easeOut(duration: 0.3)) {
                self.position = positionAbove
            }
        } else {
            self.position = closestPosition
        }
    }
    
    private func opacity(for whiteLevel: CGFloat) -> Double {
        switch whiteLevel {
        case 0...0.2:
            return 0.8
        case 0.21...0.3:
            return 0.65
        case 0.31...0.5:
            return 0.6
        case 0.51...0.7:
            return 0.5
        case 0.71...0.87:
            return 0.35
        case 0.88...1:
            return 0.3
        default:
            return 1.0
        }
    }
    
    private func textColorFor(isTooLight: Bool) -> Color {
        return isTooLight ? Color.white : Color.white
    }
    
    private func nowPlayingStateBackground(isFullScreen: Bool) -> Color {
        return backgroundColorFor(isTooLight: nowPlayingViewModel.isTooLight).opacity(opacity(for: nowPlayingViewModel.whiteLevel))
//        if isFullScreen {
//            return backgroundColorFor(isTooLight: nowPlayingViewModel.isTooLight).opacity(opacity(for: nowPlayingViewModel.whiteLevel))
//        } else {
//            return backgroundColorFor(isTooLight: nowPlayingViewModel.isTooLight).opacity(opacity(for: nowPlayingViewModel.whiteLevel))
//            return Color.nowPlayingBG.opacity(0.4)
//            return Color.clear
//        }
    }
    
    private func backgroundColorFor(isTooLight: Bool) -> Color {
        return isTooLight ? nowPlayingViewModel.darkerAccentColor.opacity(opacity(for: nowPlayingViewModel.whiteLevel)) : nowPlayingViewModel.lighterAccentColor.opacity(opacity(for: nowPlayingViewModel.whiteLevel))
    }
}

struct NowPlayingFullView_Previews: PreviewProvider {
    static var previews: some View {
        let musicController = MusicController()
        NowPlayingFullView(musicController: musicController).environmentObject(musicController.nowPlayingViewModel)
    }
}
