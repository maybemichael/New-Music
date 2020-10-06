//
//  NowPlayingView.swift
//  New-Music
//
//  Created by Michael McGrath on 10/4/20.
//

import SwiftUI
import MediaPlayer

struct NowPlayingView: View {
    @ObservedObject var viewModel: NowPlayingViewModel
//    @State var trackPercentage: CGFloat = 0
    var musicController: MusicController?
    
    var body: some View {
        ZStack {
            Color.nowPlayingBG
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 20) {
                NeuAlbumArtworkView(shape: Rectangle(), color1: .sysGrayFive, color2: .sysGrayFour, image: $viewModel.albumArtwork)
                    .frame(width: 325, height: 325)
                VStack {
                    Text(viewModel.artist)
                        .font(Font.system(.headline).weight(.medium))
                        .foregroundColor(.white)
                    Text(viewModel.songTitle)
                        .font(Font.system(.subheadline).weight(.medium))
                        .foregroundColor(.lightTextColor)
                }
                .padding(.bottom, 140)
                HStack(spacing: 40) {
                    Spacer()
                    TrackButton(imageName: "backward.fill", size: 70, trackForward: false)
                    NeuPlayPauseButton()
                        .frame(width: 80, height: 80)
                    TrackButton(imageName: "forward.fill", size: 70, trackForward: true)
                    Spacer()
                }
            }
            
            
//            VStack {
//                Spacer()
//                Text("hey")
//                    .padding(.bottom, 12)
//                    .foregroundColor(.white)
//                    .font(Font.system(.headline).weight(.bold))
//                ZStack {
//                    Pulsation()
//                    ProgressTrack()
//                    Progress(trackPercentage: trackPercentage)
//                }
//                Spacer()
//                HStack {
//                    Button(action: {
//                        self.trackPercentage = CGFloat(85)
//                    }, label: {
//                        Image(systemName: "play.circle.fill").resizable()
//                            .frame(width: 65, height: 65)
//                            .aspectRatio(contentMode: .fit)
//                            .foregroundColor(.white)
//                    })
//                }
//            }
        }
    }
    func printStuff() {
        
    }
}

struct NowPlayingView_Previews: PreviewProvider {
    static var previews: some View {
        NowPlayingView(viewModel: NowPlayingViewModel(musicController: MusicController.shared))
    }
}

struct ArtworkView: View {
    var body: some View {
        ZStack {
            
        }
    }
}


struct Progress: View {
    var trackPercentage: CGFloat = 80
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.clear)
                .frame(width: 150, height: 150)
            .overlay(
            Circle()
                .trim(from: 0.0, to: trackPercentage * 0.01)
                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                .fill(AngularGradient(gradient: .init(colors: [.blue]), center: .center, startAngle: .zero, endAngle: .init(degrees: 360)))
            ).animation(.spring(response: 2.0, dampingFraction: 1.0, blendDuration: 1.0))
        }
    }
}

struct ProgressTrack: View {
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.nowPlayingBG)
                .frame(width: 150, height: 150)
            .overlay(
            Circle()
                .stroke(style: StrokeStyle(lineWidth: 20))
                .fill(AngularGradient(gradient: .init(colors: [.sysGraySix]), center: .center))
            )
        }
    }
}

struct Pulsation: View {
    @State private var pulsate = false
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.green)
                .frame(width: 165, height: 165)
                .scaleEffect(pulsate ? 1.2 : 0.9)
                .animation(Animation.easeInOut(duration: 1.1).repeatForever(autoreverses: true))
                .onAppear {
                    self.pulsate.toggle()
            }
        }
    }
}

struct NeuButtonBackground<S: Shape>: View {
    var isHighlighted: Bool
    var shape: S
    var color1: Color
    var color2: Color
    
    var body: some View {
        ZStack {
            if isHighlighted {
                shape
                    .fill(LinearGradient(color2, color1))
//                    .overlay(
//                        shape
//                            .stroke(Color.sysGrayThree, lineWidth: 2)
//                            .blur(radius: 4)
//                            .offset(x: -2, y: -2)
//                            .mask(shape.fill(LinearGradient(Color.clear, Color.black))))
//                    .overlay(
//                        shape
//                            .stroke(Color.sysGraySix, lineWidth: 2)
//                            .blur(radius: 8)
//                            .offset(x: -2, y: -2)
//                            .mask(shape.fill(LinearGradient(Color.black, Color.clear))))
                    .shadow(color: Color.black.opacity(0.3), radius: 10, x: -3, y: -3)
                    .shadow(color: Color.white.opacity(0.1), radius: 5, x: 2, y: 2)
            } else {
                shape
                    .fill(LinearGradient(color2, color1))
                    .shadow(color: Color.black.opacity(0.5), radius: 10, x: 5, y: 5)
                    .shadow(color: Color.white.opacity(0.15), radius: 10, x: -3, y: -3)
            }
        }
        .frame(width: 70, height: 70)
    }
}

struct NeuButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(30)
            .contentShape(Circle())
            .background(NeuButtonBackground(isHighlighted: configuration.isPressed, shape: Circle(), color1: .sysGrayFive, color2: .sysGrayFour))
    }
}

struct TrackButton: View {
    var imageName: String
    var size: CGFloat
    var trackForward: Bool
    var body: some View {
        Button(action: {
            trackForward ? MusicController.shared.nextTrack() : MusicController.shared.previousTrack()
        }) {
            Image(systemName: imageName)
                .foregroundColor(.white)
                .aspectRatio(contentMode: .fit)
                .font(Font.system(.headline).weight(.semibold))
        }
        .frame(width: size, height: size)
//        .overlay(Circle().stroke(LinearGradient(.sysGraySix, .black), lineWidth: 2))
        .buttonStyle(NeuButtonStyle())
    }
}

struct NeuToggleBackground<S: Shape>: View {
    var isToggled: Bool
    var shape: S
    var color1: Color
    var color2: Color
    
    var body: some View {
        ZStack {
            if isToggled {
                shape
                    .fill(LinearGradient(color2, color1))
                    .overlay(shape.stroke(LinearGradient(.sysGrayFive, .sysGrayFour), lineWidth: 2))
                    .shadow(color: Color.black.opacity(0.3), radius: 10, x: -2, y: -2)
                    .shadow(color: Color.white.opacity(0.1), radius: 5, x: 2, y: 2)
            } else {
                shape
                    .fill(LinearGradient(color1, color2))
                    .overlay(shape.stroke(LinearGradient(.sysGrayFour, .sysGrayFive), lineWidth: 1))
                    .shadow(color: Color.black.opacity(0.5), radius: 10, x: 5, y: 5)
                    .shadow(color: Color.white.opacity(0.15), radius: 10, x: -3, y: -3)
            }
        }
        .frame(width: 80, height: 80)
    }
}

struct ToggleButtonStyle: ToggleStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
            configuration.isOn ? MusicController.shared.play() : MusicController.shared.pause()
        }) {
            configuration.label
                .padding(30)
                .contentShape(Circle())
                .background(NeuToggleBackground(isToggled: configuration.isOn, shape: Circle(), color1: .sysGrayFour, color2: .sysGrayFive))
        }
    }
}

struct NeuPlayPauseButton: View {
    
    @State var isPlaying = false
    
    var body: some View {
        Toggle(isOn: $isPlaying) {
            Image(systemName: isPlaying ? "pause": "play.fill")
                .foregroundColor(.white)
                .aspectRatio(contentMode: .fit)
                .font(Font.system(.callout).weight(.black))
        }
        .toggleStyle(ToggleButtonStyle())
    }
}

struct NeuAlbumArtworkView<S: Shape>: View {
    var shape: S
    var color1: Color
    var color2: Color
    @Binding var image: UIImage?
    
    var body: some View {
        ZStack {
            shape
                .fill(LinearGradient(color1, color2))
                .overlay(
                    shape
                        .stroke(Color.black, lineWidth: 4)
                        .blur(radius: 4)
                        .offset(x: 10, y: 10)
                        .mask(shape.fill(LinearGradient(Color.clear, Color.black))))
                .overlay(
                    shape
                        .stroke(Color.nowPlayingBG, lineWidth: 4)
                        .blur(radius: 4)
                        .offset(x: -10, y: -10)
                        .mask(shape.fill(LinearGradient(Color.black, Color.clear))))
                .overlay(shape.stroke(LinearGradient(.sysGraySix, .black), lineWidth: 10))
                .shadow(color: Color.black.opacity(0.9), radius: 10, x: 5, y: 5)
                .shadow(color: Color.white.opacity(0.1), radius: 7, x: -3, y: -3)
//                .shadow(color: Color.white.opacity(0.1), radius: 7, x: -3, y: -3)
            Image(uiImage: image ?? UIImage())
                .resizable()
                .scaledToFit()
                .frame(width: 315, height: 315)
        }
    }
}
