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
    @Namespace var artworkAnimation
    var frame: CGRect
    let musicController: MusicController
    var frameDelegate: FrameDelegate
    
    var body: some View {
        GeometryReader { geo in
            
//            ZStack {
//                Color.clear
//                    .edgesIgnoringSafeArea(.all)
            VStack {
                GeometryReader { geometry in
                    if nowPlayingViewModel.isFullScreen {
                        ArtworkView2(size: UIScreen.main.bounds.width - 80)
                            .position(x: ((UIScreen.main.bounds.width - 80) / 2), y:  ((UIScreen.main.bounds.width - 80) / 2))
//                            .position(x: frame.midX, y: frame.midY)
                            .frame(width: UIScreen.main.bounds.width - 80, height: UIScreen.main.bounds.width - 80)
                            .onAppear {
                                let frame = CGRect(x: geometry.frame(in: .global).origin.x - ((UIScreen.main.bounds.width - 80) * 0.015), y: geometry.frame(in: .global).origin.y - ((UIScreen.main.bounds.width - 80) * 0.015), width: geometry.frame(in: .global).size.width + ((UIScreen.main.bounds.width - 80) * 0.03), height: geometry.frame(in: .global).size.height + ((UIScreen.main.bounds.width - 80) * 0.03))
                                nowPlayingViewModel.fullImageFrame = frame
                                print("Full Image View Frame: \(nowPlayingViewModel.fullImageFrame)")
                                frameDelegate.getFrame(frame: frame)
                            }.animation(.easeIn(duration: 0.65))
                            .onChange(of: nowPlayingViewModel.getFrame, perform: { value in
                                nowPlayingViewModel.fullImageFrame = geometry.frame(in: .global)
                                print("Full Image View Frame: \(nowPlayingViewModel.fullImageFrame)")
                                frameDelegate.getFrame(frame: geometry.frame(in: .global))
                            })
                    } else {
                        Rectangle()
                            .foregroundColor(.clear)
                        
                    }
                }
                .frame(width: UIScreen.main.bounds.width - 80, height: UIScreen.main.bounds.width - 80)
                    //                    .edgesIgnoringSafeArea(.all)
                    //                    .position(x: geo.frame(in: .local).maxX, y: geo.frame(in: .local).minY)
                    //                    .frame(alignment: .center)
                    //            }
                    //            else {
                    //                    .frame(width: UIScreen.main.bounds.width - 80, height: UIScreen.main.bounds.width - 80)
                    //                    .frame(width: UIScreen.main.bounds.width - 80, height: UIScreen.main.bounds.width - 80)
                    //                    .frame(width: frame.width, height: frame.height, alignment: .center)
                    //            }
                    //            .frame(minWidth: 60, maxWidth: UIScreen.main.bounds.width - 80, minHeight: 60, maxHeight: UIScreen.main.bounds.width - 80, alignment: .center)/
                    VStack(alignment: .center) {
                        Text(nowPlayingViewModel.artist)
                            //                Text("Fall Out Boy")
                            .font(Font.system(.title3).weight(.medium))
                            .foregroundColor(nowPlayingViewModel.textColor2)
                            .multilineTextAlignment(.center)
                        Text(nowPlayingViewModel.songTitle)
                            //                Text("Grand Theft Autumn")
                            .font(Font.system(.title3).weight(.medium))
                            .foregroundColor(textColorFor(isTooLight: nowPlayingViewModel.isTooLight))
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                        
                    }
                    .frame(minHeight: 80, alignment: .center)
                    TrackProgressBarView(musicController: musicController)
                    HStack(spacing: 40) {
                        NeuTrackButton(size: UIScreen.main.bounds.width / 7, trackDirection: .trackBackward, musicController: musicController)
                            .frame(width: UIScreen.main.bounds.width / 7, height: UIScreen.main.bounds.width / 7, alignment: .center)
                        NeuPlayPauseButton(isPlaying: nowPlayingViewModel.isPlaying, musicController: musicController, labelPadding: 30, size: UIScreen.main.bounds.width / 4.7)
                            .frame(width: UIScreen.main.bounds.width / 4.7, height: UIScreen.main.bounds.width / 4.7, alignment: .center)
                        NeuTrackButton(size: UIScreen.main.bounds.width / 7, trackDirection: .trackForward, musicController: musicController)
                            .frame(width: UIScreen.main.bounds.width / 7, height: UIScreen.main.bounds.width / 7, alignment: .center)
                    }
                    
//                }
//                .frame(width: geo.size.width, height: geo.size.height)
                }
                .padding(.horizontal, 40)
                .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                .edgesIgnoringSafeArea(.all)

        }
        .frame(width: UIScreen.main.bounds.width)
        .background(nowPlayingStateBackground(animateColor: nowPlayingViewModel.shouldAnimateColorChange).animation(.linear(duration: 0.4)))
        .edgesIgnoringSafeArea(.all)
//        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        //        }
//        .background(backgroundColorFor(isTooLight: nowPlayingViewModel.isTooLight))
        .coordinateSpace(name: "FullNowPlayingView")
    }
    
    
    
    private func getTopInset() -> CGFloat {
        guard let topInset = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first?.safeAreaInsets.top else { return 30 }
        return topInset + 10
    }
    
    private func setOffset() -> CGFloat {
        return self.position + self.dragState.translation.height
    }
    
    private func getCenterX() -> CGFloat {
        let imageWidth = UIScreen.main.bounds.width - 80
        let halfWidth: CGFloat = imageWidth / 2
        let margin: CGFloat = 40
        return margin + halfWidth
    }
    private func getCenterY() -> CGFloat {
        let imageWidth = UIScreen.main.bounds.width - 80
        let halfHeight: CGFloat = imageWidth / 2
        let topMargin = UIScreen.main.bounds.height / 6
        return topMargin + halfHeight
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
    
    private func nowPlayingStateBackground(animateColor: Bool) -> Color {
//        return backgroundColorFor(isTooLight: nowPlayingViewModel.isTooLight).opacity(opacity(for: nowPlayingViewModel.whiteLevel))
        if animateColor {
            return backgroundColorFor(isTooLight: nowPlayingViewModel.isTooLight).opacity(opacity(for: nowPlayingViewModel.whiteLevel))
        } else {
            return Color.nowPlayingBG.opacity(0.4)
        }
    }
    
    private func backgroundColorFor(isTooLight: Bool) -> Color {
        return isTooLight ? nowPlayingViewModel.darkerAccentColor.opacity(opacity(for: nowPlayingViewModel.whiteLevel)) : nowPlayingViewModel.lighterAccentColor.opacity(opacity(for: nowPlayingViewModel.whiteLevel))
    }
}

struct NowPlayingFullView_Previews: PreviewProvider {
    static var previews: some View {
        let musicController = MusicController()
        NowPlayingFullView(frame: CGRect(x: 40, y: UIScreen.main.bounds.height / 6, width: UIScreen.main.bounds.width - 80, height: UIScreen.main.bounds.width - 80), musicController: musicController, frameDelegate: NowPlayingFullViewController()).environmentObject(musicController.nowPlayingViewModel)
    }
}

//func artworkView(frame: CGRect) -> some View {
//    Rectangle()
//        .background(Color.blue)
//        .position(frame.origin)
//}
