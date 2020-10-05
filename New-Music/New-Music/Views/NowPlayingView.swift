//
//  NowPlayingView.swift
//  New-Music
//
//  Created by Michael McGrath on 10/4/20.
//

import SwiftUI

struct NowPlayingView: View {
    
    @State var trackPercentage: CGFloat = 20
    
    var body: some View {
        ZStack {
            Color.nowPlayingBG.edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                Text("hey")
                    .padding(.bottom, 12)
                    .foregroundColor(.white)
                    .font(Font.system(.headline).weight(.bold))
                ZStack {
                    Pulsation()
                    ProgressTrack()
                    Progress(trackPercentage: trackPercentage)
                }
                Spacer()
                HStack {
                    Button(action: {
                        self.trackPercentage = CGFloat(85)
                    }, label: {
                        Image(systemName: "play.circle.fill").resizable()
                            .frame(width: 65, height: 65)
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.sysGraySix)
                    })
                }
            }
        }
    }
}

struct NowPlayingView_Previews: PreviewProvider {
    static var previews: some View {
        NowPlayingView()
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
