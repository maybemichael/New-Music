//
//  NowPlayingIndicatorView.swift
//  New-Music
//
//  Created by Michael McGrath on 11/15/20.
//

import SwiftUI

struct NowPlayingIndicatorView: View {
    @EnvironmentObject var nowPlayingViewModel: NowPlayingViewModel
    @State private var phase = 3.14 * 8
    var song: Song
    
    var body: some View {
        ZStack(alignment: .top) {
            ForEach(0..<10) { i in
                Wave(strength: 12, frequency: 10, phase: self.phase)
                    .stroke(nowPlayingViewModel.darkerAccentColor.opacity(Double(i) / 10), lineWidth: 1)
                    .offset(y: CGFloat(i) * 2)
                Wave(strength: 10, frequency: 12, phase: self.phase)
                    .stroke(nowPlayingViewModel.darkerAccentColor.opacity(Double(i) / 10), lineWidth: 1)
                    .offset(y: CGFloat(i) * 2)
                Wave(strength: 8, frequency: 20, phase: self.phase)
                    .stroke(nowPlayingViewModel.darkerAccentColor.opacity(Double(i) / 10), lineWidth: 1)
                    .offset(y: CGFloat(i) * 2)
            }
        }
//            .frame(width: 70, height: 70)
        .background(Color.clear)
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                self.phase = .pi * 4
            }
        }
    }

}

struct NowPlayingIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        let musicController = MusicController()
//        NowPlayingIndicatorView(song: Song(songName: "", artistName: "", imageURL: URL(string: "")!)).environmentObject(musicController.nowPlayingViewModel)
        
        MusicNoteView(size: 80).environmentObject(musicController.nowPlayingViewModel)
    }
}

struct Wave: Shape {
    var animatableData: Double {
        get { phase }
        set { self.phase = newValue }
    }
    var strength: Double
    var frequency: Double
    var phase: Double

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath()
        let width = Double(rect.width)
        let height = Double(rect.height)
        let midWidth = width / 2
        let midHeight = height / 2
        let oneOverMidWidth = 1 / midWidth
        let wavelength = width / frequency
        path.move(to: CGPoint(x: 0, y: midHeight))
        for x in stride(from: 0, through: width, by: 1) {
            let relativeX = x / wavelength
            let distanceFromMidWidth = x - midWidth
            let normalDistance = oneOverMidWidth * distanceFromMidWidth
            let parabola = -(normalDistance * normalDistance) + 1
            let sine = sin(relativeX + phase)
            let y = parabola * strength * sine + midHeight
            path.addLine(to: CGPoint(x: x, y: y))
        }

        return Path(path.cgPath)
    }
}

struct MusicNoteView: View {
    @EnvironmentObject var nowPlayingViewModel: NowPlayingViewModel
    @State var animate = false
    @State private var animationAmount: CGFloat = 1
    var size: CGFloat
    var body: some View {
        ZStack {
            LinearGradient(direction: .topTrailingBottomLeading, nowPlayingViewModel.lighterAccentColor.opacity(1.0), nowPlayingViewModel.darkerAccentColor.opacity(1.0))
                .frame(width: size, height: size)
                .mask(getImage().aspectRatio(contentMode: .fit).frame(width: size, height: size))
                .aspectRatio(contentMode: .fit)
//                .scaleEffect(self.animationAmount)
                .scaleEffect(self.animate ? 1.5 : 0.8)
                .animation(Animation.linear(duration: getAnimationDuration()).repeatForever(autoreverses: true))
        }
        .onAppear {
            self.animationAmount = self.animationAmount == 1.5 ? 1 : 1.5
            self.animate.toggle()
        }
    }
    
    private func getImage() -> Image {
        Image(systemName: "music.note")
            .resizable()
    }
    
    private func getAnimationDuration() -> Double {
        return 60 / Double(nowPlayingViewModel.beatsPerMinute)
    }
}
