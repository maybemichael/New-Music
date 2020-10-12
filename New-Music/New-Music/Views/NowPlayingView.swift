//
//  NowPlayingView.swift
//  New-Music
//
//  Created by Michael McGrath on 10/4/20.
//

import SwiftUI
import MediaPlayer

struct NowPlayingView: View {
    @ObservedObject var song: NowPlayingViewModel
    var musicController: MusicController!
   
    var body: some View {
        ZStack {
            Color.nowPlayingBG
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 0) {
                NeuAlbumArtworkView(shape: Rectangle(), color1: .sysGraySix, color2: .black, viewModel: song)
                    .frame(width: 325, height: 325)
                    .padding(.bottom, 20)
                VStack {
                    Text(song.artist)
                        .font(Font.system(.title).weight(.light))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    Text(song.songTitle)
                        .font(Font.system(.headline).weight(.medium))
                        .foregroundColor(.lightTextColor)
                        .multilineTextAlignment(.center)
                }
                .padding(.bottom, 40)
                
                TrackProgressView(song: song, musicController: musicController)
                    .padding(.bottom, 20)
                HStack(spacing: 40) {
                    Spacer()
                    TrackButton(imageName: "backward.fill", size: 70, trackDirection: .trackBackward, musicController: musicController)
                    NeuPlayPauseButton(viewModel: song, isPlaying: song.isPlaying, musicController: musicController, symbolConfig: .playButton)
                        .frame(width: 85, height: 85)
                    TrackButton(imageName: "forward.fill", size: 70, trackDirection: .trackForward, musicController: musicController)
                    Spacer()
                }
            }
        }
    }
}

struct NowPlayingView_Previews: PreviewProvider {
    static var previews: some View {
        let musicController = MusicController()
        NowPlayingView(song: musicController.nowPlayingViewModel, musicController: musicController)
        
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
    var trackDirection: TrackDirection
    var musicController: MusicController
    var body: some View {
        Button(action: {
            trackDirection == .trackForward ? musicController.nextTrack() : musicController.previousTrack()
        }) {
            Image(systemName: imageName)
                .foregroundColor(.white)
                .aspectRatio(contentMode: .fit)
                .font(Font.system(.headline).weight(.semibold))
        }
        .frame(width: size, height: size)
        .buttonStyle(NeuButtonStyle())
    }
}

struct NeuToggleBackground<S: Shape>: View {
    @State var isToggled: Bool
    @ObservedObject var viewModel: NowPlayingViewModel
    var shape: S
    var color1: Color
    var color2: Color
    
    var body: some View {
        ZStack {
            if viewModel.isPlaying {
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
                .background(NeuToggleBackground(isToggled: configuration.isOn, viewModel: viewModel, shape: Circle(), color1: .sysGrayFour, color2: .sysGrayFive))
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
                .foregroundColor(.white)
                .aspectRatio(contentMode: .fit)
                .font(Font.system(.callout).weight(.black))
                
        }
        .toggleStyle(ToggleButtonStyle(musicController: musicController, viewModel: viewModel))
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
                .shadow(color: Color.white.opacity(0.1), radius: 7, x: -3, y: -3)
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(width: 315, height: 315)
        }.onReceive(self.viewModel.didChange, perform: { receivedImage in
            self.image = receivedImage ?? UIImage()
        })
    }
}

struct TrackProgressView: View {
    
    @ObservedObject var song: NowPlayingViewModel
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
                                                    Gradient(stops: [Gradient.Stop(color: .sysGrayFour, location: 0.1),
                                                                     Gradient.Stop(color: Color.black.opacity(0.7), location: 0.9)]),
                                                 startPoint: .bottom,
                                                 endPoint: .top))
                            .frame(height: 10)
                            .padding(.top, 1)
                    }
                }
                GeometryReader { geo in
                    HStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.fikeBG)
                            .frame(width: geo.size.width * self.percentagePlayedForSong(), height: 10)
                            .padding(.top, 1)
                        Spacer(minLength: 0)
                    }
                }
                GeometryReader { geo in
                    HStack {
                        Circle()
                            .fill(Color.fikeBG)
                            .frame(width: 12, height: 12)
                            .animation(nil)
                            .scaleEffect(isDragging ? 1.5 : 1)
                            .padding(.leading, geo.size.width * self.percentagePlayedForSong() - 7)
                            
                            .gesture(
                                DragGesture()
                                    .onChanged({ value in
                                        self.isDragging = true 
                                        musicController.musicPlayer.beginSeekingForward()
                                        self.song.elapsedTime = self.time(for: value.location.x, in: geo.size.width)
                                            
                                    })
                                    
                                    .onEnded({ value in
                                        self.isDragging = false
                                        musicController.musicPlayer.currentPlaybackTime = self.time(for: value.location.x, in: geo.size.width)
                                        musicController.musicPlayer.endSeeking()
                                    })
                            )
                        Spacer(minLength: 0)
                    }
                }
                HStack {
                    Text(formattedTimeFor(timeInterval: song.elapsedTime))
                        .font(Font.system(.headline).weight(.regular))
                        .foregroundColor(.white)
                    Spacer()
                    Text(formattedTimeFor(timeInterval: song.duration))
                        .font(Font.system(.headline).weight(.regular))
                        .foregroundColor(.white)
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width - 80, height: 80)
        .padding(.top, 50)
    }
    
    func formattedTimeFor(timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSinceReferenceDate: timeInterval)
        return dateFormatter.string(from: date)
    }

    func time(for location: CGFloat, in width: CGFloat) -> TimeInterval {
        let percentage = location / width
        let time = song.duration * TimeInterval(percentage)
        if time < 0 {
            return 0
        } else if time > song.duration {
            return song.duration
        }
        return time
    }

    func percentagePlayedForSong() -> CGFloat {
        let percentagePlayed = CGFloat(song.elapsedTime / song.duration)
        return percentagePlayed.isNaN ? 0.0 : percentagePlayed
    }
}
