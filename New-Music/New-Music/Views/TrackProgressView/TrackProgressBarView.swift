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
        TrackProgressView(musicController: musicController, barHeight: 8, indicatorHeight: 14, barWidth: UIScreen.main.bounds.width - 80)
    }
}

struct TrackProgressBarView_Previews: PreviewProvider {
    static var previews: some View {
        let musicController = MusicController()
        TrackProgressBarView(musicController: musicController).environmentObject(musicController.nowPlayingViewModel)
    }
}

struct TrackProgressView: View {
    @EnvironmentObject var nowPlayingViewModel: NowPlayingViewModel
    @State var isDragging: Bool = false
    var musicController: MusicController
    var newPlaybackTime: TimeInterval = 0
    var barHeight: CGFloat
    var indicatorHeight: CGFloat
    var barWidth: CGFloat
    
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "m:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    var body: some View {
        VStack {
            ZStack(alignment: .center) {
                GeometryReader { geo in
                    HStack {
                        RoundedRectangle(cornerRadius: barHeight / 2)
                            .fill(LinearGradient(gradient:
                                Gradient(stops: [Gradient.Stop(color: .sysGrayFour, location: 0.2),
                                                 Gradient.Stop(color: Color.black.opacity(0.75), location: 0.9)]),
                                                 startPoint: .bottom,
                                                 endPoint: .top))
                            .frame(height: barHeight)
                            .padding(.top, (indicatorHeight - barHeight) / 2)
                    }
                }
                GeometryReader { geo in
                    HStack {
                        RoundedRectangle(cornerRadius: barHeight / 2)
                            .fill(fillGradient(whiteLevel: nowPlayingViewModel.whiteLevel))
                            .frame(width: geo.size.width * self.percentagePlayedForSong(), height: barHeight)
                            .overlay(RoundedRectangle(cornerRadius: barHeight / 2)
                                        .stroke(Color.black, lineWidth: 1))
                            .padding(.top, (indicatorHeight - barHeight) / 2)
                        Spacer(minLength: 0)
                    }
                }
                GeometryReader { geo in
                    HStack {
                        Circle()
                            .fill(fillGradient(whiteLevel: nowPlayingViewModel.whiteLevel))
                            .frame(width: indicatorHeight, height: indicatorHeight)
                            .scaleEffect(isDragging ? 2.5 : 1)
                            .padding(.leading, geo.size.width * self.percentagePlayedForSong() - (indicatorHeight / 2))
                            .gesture(
                                DragGesture()
                                    .onChanged({ value in
                                        self.isDragging = true
                                        nowPlayingViewModel.displaylink?.invalidate()
                                        nowPlayingViewModel.displaylink = nil
                                        self.nowPlayingViewModel.elapsedTime = self.time(for: value.location.x, in: geo.size.width)
                                            
                                    })
                                    .onEnded({ value in
                                        self.isDragging = false
                                        musicController.musicPlayer.currentPlaybackTime = self.time(for: value.location.x, in: geo.size.width)
                                        nowPlayingViewModel.newDisplayLink()
                                    })
                            )
                        Spacer(minLength: 0)
                    }
                }
                HStack(alignment: .center) {
                    Text(formattedTimeFor(timeInterval: nowPlayingViewModel.elapsedTime))
                        .font(.custom("CourierNewPS-BoldMT", size: indicatorHeight, relativeTo: .title3))
                        .foregroundColor(.white)
//                        .foregroundColor(fontColor(isTooLight: nowPlayingViewModel.isTooLight))
                    Spacer()
                    Text("-\(formattedTimeRemainingFor(timeInterval: nowPlayingViewModel.timeRemaining))")
                        .font(.custom("CourierNewPS-BoldMT", size: indicatorHeight, relativeTo: .title3))
                        .foregroundColor(.white)
//                        .foregroundColor(fontColor(isTooLight: nowPlayingViewModel.isTooLight))
                }
            }
        }
        .frame(width: barWidth, height: 60, alignment: .bottom)
    }
    
    private func fillGradient(whiteLevel: CGFloat) -> LinearGradient {
        if whiteLevel < 0.01 {
            return LinearGradient(gradient: Gradient(colors: [nowPlayingViewModel.darkerAccentColor, nowPlayingViewModel.darkerAccentColor]), startPoint: .leading, endPoint: .trailing)
        } else {
            return LinearGradient(gradient: Gradient(colors: [nowPlayingViewModel.lighterAccentColor, nowPlayingViewModel.darkerAccentColor]), startPoint: .leading, endPoint: .trailing)
        }
    }
    
    private func formattedTimeRemainingFor(timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSinceReferenceDate: timeInterval)
        return dateFormatter.string(from: date)
    }
    
    private func formattedTimeFor(timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSinceReferenceDate: timeInterval)
        return dateFormatter.string(from: date)
    }

    private func time(for location: CGFloat, in width: CGFloat) -> TimeInterval {
        let percentage = location / width
        let time = nowPlayingViewModel.duration * TimeInterval(percentage)
        if time < 0 {
            return 0
        } else if time > nowPlayingViewModel.duration {
            return nowPlayingViewModel.duration
        }
        return time
    }

    private func percentagePlayedForSong() -> CGFloat {
        let percentagePlayed = CGFloat(nowPlayingViewModel.elapsedTime / nowPlayingViewModel.duration)
        return percentagePlayed.isNaN ? 0.0 : percentagePlayed
    }
    
    private func fontColor(isTooLight: Bool) -> Color {
        isTooLight ? Color.black : Color.white
    }
}
