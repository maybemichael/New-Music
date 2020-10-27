//
//  TrackProgressBarView.swift
//  New-Music
//
//  Created by Michael McGrath on 10/26/20.
//

import SwiftUI

struct TrackProgressBarView: View {
    @EnvironmentObject var nowPlayingViewModel: NowPlayingViewModel
    var musicController: MusicController
    var body: some View {
        TrackProgressView(musicController: musicController)
    }
}

struct TrackProgressBarView_Previews: PreviewProvider {
    static var previews: some View {
        let musicController = MusicController()
        TrackProgressBarView(musicController: musicController).environmentObject(musicController.nowPlayingViewModel)
    }
}

struct TrackProgressView: View {
    @EnvironmentObject var songViewModel: NowPlayingViewModel
    @State var isDragging: Bool = false
    var musicController: MusicController
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
