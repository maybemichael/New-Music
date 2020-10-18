//
//  NowPlayingView.swift
//  New-Music
//
//  Created by Michael McGrath on 10/4/20.
//

import SwiftUI
import MediaPlayer

struct NowPlayingView: View {
    @ObservedObject var songViewModel: NowPlayingViewModel
    var musicController: MusicController!
   
    var body: some View {
        ZStack {
            LinearGradient(.sysGrayThree, .nowPlayingBG)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 0) {
                NeuAlbumArtworkView(shape: Rectangle(), color1: .sysGraySix, color2: .black, viewModel: songViewModel)
                    .frame(width: 325, height: 325)
                    .padding(.bottom, 20)
                VStack {
                    Text(songViewModel.artist)
                        .font(Font.system(.title).weight(.light))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    Text(songViewModel.songTitle)
                        .font(Font.system(.headline).weight(.medium))
                        .foregroundColor(.lightTextColor)
                        .multilineTextAlignment(.center)
//                    Text("White Level: \(songViewModel.whiteLevel)")
//                        .font(Font.system(.headline).weight(.medium))
//                        .foregroundColor(.white)
                }
                .frame(minHeight: 80)
//                .padding(.bottom, 40)
                .padding(.leading, 40)
                .padding(.trailing, 40)
                
                TrackProgressView(songViewModel: songViewModel, musicController: musicController)
                    .padding(.bottom, 12)
                HStack(spacing: 40) {
                    Spacer()
                    TrackButton(imageName: "backward.fill", size: 60, trackDirection: .trackBackward, musicController: musicController, songViewModel: songViewModel)
                    NeuPlayPauseButton(viewModel: songViewModel, isPlaying: songViewModel.isPlaying, musicController: musicController, symbolConfig: .playButton)
                        .frame(width: 90, height: 90)
                    TrackButton(imageName: "forward.fill", size: 60, trackDirection: .trackForward, musicController: musicController, songViewModel: songViewModel)
                    Spacer()
                }
            }
        }
    }
}

struct NowPlayingView_Previews: PreviewProvider {
    static var previews: some View {
        let musicController = MusicController()
        NowPlayingView(songViewModel: musicController.nowPlayingViewModel, musicController: musicController)
        
    }
}

struct ArtworkView: View {
    var body: some View {
        ZStack {
            
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
    var size: CGFloat
    @ObservedObject var songViewModel: NowPlayingViewModel
    
    var body: some View {
        ZStack {
            if songViewModel.whiteLevel < 0.3 {
                if isHighlighted {
                    shape
                        .fill(gradient(for: isHighlighted))
                        .overlay(
                            shape
                                .stroke(songViewModel.lighterAccentColor, lineWidth: 2)
                                .blur(radius: 4)
                                .offset(x: -2, y: -2)
                                .mask(shape.fill(LinearGradient(Color.clear, Color.black))))
                        .overlay(
                            shape
                                .stroke(songViewModel.darkerAccentColor, lineWidth: 2)
                                .blur(radius: 8)
                                .offset(x: -2, y: -2)
                                .mask(shape.fill(LinearGradient(Color.black, Color.clear))))
                        .shadow(color: Color.black.opacity(0.5), radius: 10, x: 7, y: 7)
                        .shadow(color: Color.white.opacity(0.5), radius: 10, x: -7, y: -7)
                        .blendMode(.overlay)
                    shape
                        .fill(gradient(for: isHighlighted))
                        .overlay(shape.stroke(LinearGradient(.blackGradient, .black), lineWidth: 2))
                } else {
                    shape
                        .fill(gradient(for: isHighlighted))
                        .shadow(color: Color.black.opacity(0.5), radius: 10, x: 10, y: 10)
                        .shadow(color: Color.white.opacity(0.5), radius: 10, x: -10, y: -10)
                        .blendMode(.overlay)
                    shape
                        .fill(LinearGradient(songViewModel.lighterAccentColor, songViewModel.darkerAccentColor))
                        .overlay(shape.stroke(LinearGradient(.blackGradient, .black), lineWidth: 2))
                }
            } else {
                if isHighlighted {
                    shape
                        .fill(gradient(for: isHighlighted))
                        .overlay(
                            shape
                                .stroke(songViewModel.lighterAccentColor, lineWidth: 2)
                                .blur(radius: 4)
                                .offset(x: -2, y: -2)
                                .mask(shape.fill(LinearGradient(Color.clear, Color.black))))
                        .overlay(
                            shape
                                .stroke(songViewModel.darkerAccentColor, lineWidth: 2)
                                .blur(radius: 8)
                                .offset(x: -2, y: -2)
                                .mask(shape.fill(LinearGradient(Color.black, Color.clear))))
                        .shadow(color: Color.black.opacity(0.7), radius: 8, x: 7, y: 7)
                        .shadow(color: Color.white.opacity(0.8), radius: 8, x: -7, y: -7)
                        .blendMode(.overlay)
                    shape
                        .fill(gradient(for: isHighlighted))
                        .overlay(shape.stroke(LinearGradient(.blackGradient, .black), lineWidth: 2))
                } else {
                    shape
                        .fill(gradient(for: isHighlighted))
                        .shadow(color: Color.black.opacity(0.7), radius: 8, x: 10, y: 10)
                        .shadow(color: Color.white.opacity(0.8), radius: 8, x: -10, y: -10)
                        .blendMode(.overlay)
                    shape
                        .fill(LinearGradient(songViewModel.lighterAccentColor, songViewModel.darkerAccentColor))
                        .overlay(shape.stroke(LinearGradient(.blackGradient, .black), lineWidth: 2))
                }
            }
        }
        .frame(width: 60, height: 60)
    }
    
    private func gradient(for state: Bool) -> LinearGradient {
        state ? LinearGradient(songViewModel.darkerAccentColor, songViewModel.lighterAccentColor) : LinearGradient(songViewModel.darkerAccentColor, songViewModel.lighterAccentColor)
    }
}

struct NeuButtonStyle: ButtonStyle {
    var songViewModel: NowPlayingViewModel
    var lighterColor: Color
    var darkerColor: Color
    var size: CGFloat
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(30)
            .contentShape(Circle())
            .background(NeuButtonBackground(isHighlighted: configuration.isPressed, shape: Circle(), size: size, songViewModel: songViewModel))
    }
}

struct TrackButton: View {
    var imageName: String
    var size: CGFloat
    var trackDirection: TrackDirection
    var musicController: MusicController
    @ObservedObject var songViewModel: NowPlayingViewModel
    
    var body: some View {
        Button(action: {
            trackDirection == .trackForward ? musicController.nextTrack() : musicController.previousTrack()
        }) {
            Image(systemName: imageName)
                .foregroundColor(imageTint(isTooLight: songViewModel.isTooLight))
                .aspectRatio(contentMode: .fit)
                .font(Font.system(.headline).weight(.semibold))
        }
        .frame(width: size, height: size)
        .buttonStyle(NeuButtonStyle(songViewModel: songViewModel, lighterColor: songViewModel.lighterAccentColor, darkerColor: songViewModel.darkerAccentColor, size: size))
    }
    func imageTint(isTooLight: Bool) -> Color {
        isTooLight ? Color.black : Color.white
    }
}

struct NeuToggleBackground<S: Shape>: View {
    @State var isToggled: Bool
    @ObservedObject var viewModel: NowPlayingViewModel
    var shape: S
    var lighterColor: Color
    var darkerColor: Color
    
    var body: some View {
        ZStack {
            if viewModel.whiteLevel < 0.3 {
                shape
                    .fill(gradient(for: viewModel.isPlaying))
                    .shadow(color: Color.white.opacity(0.5), radius: 12, x: -10, y: -10)
                    .shadow(color: Color.black.opacity(0.5), radius: 12, x: 10, y: 10)
                    .blendMode(.overlay)
                shape
                    .fill(gradient(for: viewModel.isPlaying))
                    .overlay(shape.stroke(LinearGradient(.blackGradient, .black), lineWidth: 2))
            } else {
                shape
                    .fill(gradient(for: viewModel.isPlaying))
                    .shadow(color: Color.white.opacity(0.9), radius: 10, x: -10, y: -10)
                    .shadow(color: Color.black.opacity(0.5), radius: 10, x: 10, y: 10)
                    .blendMode(.overlay)
                shape
                    .fill(gradient(for: viewModel.isPlaying))
                    .overlay(shape.stroke(LinearGradient(.blackGradient, .black), lineWidth: 2))
            }
        }
        .frame(width: 90, height: 90)
    }
    private func gradient(for state: Bool) -> LinearGradient {
        state ? LinearGradient(viewModel.darkerAccentColor, viewModel.lighterAccentColor) : LinearGradient(viewModel.lighterAccentColor, viewModel.darkerAccentColor)
    }
}

struct ToggleButtonStyle: ToggleStyle {
    var musicController: MusicController
    @ObservedObject var viewModel: NowPlayingViewModel
    
    func makeBody(configuration: Self.Configuration) -> some View {
        Button(action: {
            viewModel.isPlaying.toggle()
            configuration.isOn = viewModel.isPlaying ? true : false
            configuration.isOn ? musicController.play() : musicController.pause()
        }) {
            configuration.label
                .padding(30)
                .contentShape(Circle())
                .background(NeuToggleBackground(isToggled: configuration.isOn, viewModel: viewModel, shape: Circle(), lighterColor: viewModel.lighterAccentColor, darkerColor: viewModel.darkerAccentColor))
        }
    }
}

struct NeuPlayPauseButton: View {
    @ObservedObject var viewModel: NowPlayingViewModel
    @State var isPlaying: Bool
    var musicController: MusicController
    var symbolConfig: UIImage.SymbolConfiguration
    
    var body: some View {
        Toggle(isOn: $isPlaying) {
            Image(systemName: viewModel.isPlaying ? "pause": "play.fill")
                .resizable()
                .foregroundColor(imageTint(isTooLight: viewModel.isTooLight))
                .aspectRatio(contentMode: .fit)
                .font(Font.system(.callout).weight(.black))
                
        }
        .toggleStyle(ToggleButtonStyle(musicController: musicController, viewModel: viewModel))
    }
    
    func imageTint(isTooLight: Bool) -> Color {
        isTooLight ? Color.black : Color.white
    }
    
    private func gradient(for state: Bool) -> LinearGradient {
        state ? LinearGradient(viewModel.darkerAccentColor, viewModel.lighterAccentColor) : LinearGradient(viewModel.lighterAccentColor, viewModel.darkerAccentColor)
    }
    
    func symbolForState() -> UIImage {
        guard
            let play = UIImage(systemName: "play.fill", withConfiguration: symbolConfig)?.withTintColor(.white),
            let pause = UIImage(systemName: "pause", withConfiguration: symbolConfig)?.withTintColor(.white)
        else { return UIImage() }
        return isPlaying ? pause : play
    }
}

struct NeuAlbumArtworkView<S: Shape>: View {
    var shape: S
    var color1: Color
    var color2: Color
    @ObservedObject var viewModel: NowPlayingViewModel
    @State var image: UIImage = UIImage()
    
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
                .shadow(color: Color.white.opacity(0.1), radius: 10, x: -3, y: -3)
            Image(uiImage: viewModel.albumArtwork ?? UIImage())
                .resizable()
                .frame(width: 315, height: 315)
                .scaledToFit()
        }
    }
}

struct TrackProgressView: View {
    
    @ObservedObject var songViewModel: NowPlayingViewModel
    var musicController: MusicController
    @State var isDragging: Bool = false
    var newPlaybackTime: TimeInterval = 0
    
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "m:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    var body: some View {
        VStack {
            ZStack {
                GeometryReader { geo in
                    HStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(LinearGradient(gradient:
                                Gradient(stops: [Gradient.Stop(color: .sysGrayFour, location: 0.2),
                                                 Gradient.Stop(color: Color.black.opacity(0.75), location: 0.9)]),
                                                 startPoint: .bottom,
                                                 endPoint: .top))
                            .frame(height: 8)
                            .padding(.top, 3)
                    }
                }
                GeometryReader { geo in
                    HStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(fillGradient(whiteLevel: songViewModel.whiteLevel))
                            .frame(width: geo.size.width * self.percentagePlayedForSong(), height: 8)
                            .overlay(RoundedRectangle(cornerRadius: 5)
                                        .stroke(songViewModel.darkerAccentColor, lineWidth: 1))
                            .padding(.top, 3)
                        Spacer(minLength: 0)
                    }
                }
                GeometryReader { geo in
                    HStack {
                        Circle()
                            .fill(fillGradient(whiteLevel: songViewModel.whiteLevel))
                            .frame(width: 14, height: 14)
                            .animation(nil)
                            .scaleEffect(isDragging ? 2 : 1)
                            .padding(.leading, geo.size.width * self.percentagePlayedForSong() - 7)
                            
                            .gesture(
                                DragGesture()
                                    .onChanged({ value in
                                        self.isDragging = true
                                        songViewModel.timer?.invalidate()
                                        songViewModel.timer = nil
                                        self.songViewModel.elapsedTime = self.time(for: value.location.x, in: geo.size.width)
                                            
                                    })
                                    .onEnded({ value in
                                        self.isDragging = false
                                        musicController.musicPlayer.currentPlaybackTime = self.time(for: value.location.x, in: geo.size.width)
                                    })
                            )
                        Spacer(minLength: 0)
                    }
                }
                HStack {
                    Text(formattedTimeFor(timeInterval: songViewModel.elapsedTime))
                        .font(Font.system(.headline).weight(.regular))
                        .foregroundColor(.white)
                    Spacer()
                    Text(formattedTimeFor(timeInterval: songViewModel.duration))
                        .font(Font.system(.headline).weight(.regular))
                        .foregroundColor(.white)
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width - 80, height: 80)
        .padding(.top, 50)
    }
    
    private func fillGradient(whiteLevel: CGFloat) -> LinearGradient {
        if whiteLevel < 0.01 {
            return LinearGradient(gradient: Gradient(colors: [songViewModel.darkerAccentColor, songViewModel.darkerAccentColor]), startPoint: .leading, endPoint: .trailing)
        } else {
            return LinearGradient(gradient: Gradient(colors: [songViewModel.lighterAccentColor, songViewModel.darkerAccentColor]), startPoint: .leading, endPoint: .trailing)
        }
    }
    
    func formattedTimeFor(timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSinceReferenceDate: timeInterval)
        return dateFormatter.string(from: date)
    }

    func time(for location: CGFloat, in width: CGFloat) -> TimeInterval {
        let percentage = location / width
        let time = songViewModel.duration * TimeInterval(percentage)
        if time < 0 {
            return 0
        } else if time > songViewModel.duration {
            return songViewModel.duration
        }
        return time
    }

    func percentagePlayedForSong() -> CGFloat {
        let percentagePlayed = CGFloat(songViewModel.elapsedTime / songViewModel.duration)
        return percentagePlayed.isNaN ? 0.0 : percentagePlayed
    }
}
