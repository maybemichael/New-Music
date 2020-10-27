//
//  ButtonBackgrounds.swift
//  New-Music
//
//  Created by Michael McGrath on 10/26/20.
//

import SwiftUI

struct ButtonBackgrounds: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ButtonBackgrounds_Previews: PreviewProvider {
    static var previews: some View {
        ButtonBackgrounds()
    }
}

//struct NeuButtonBackground<S: Shape>: View {
//    @State var isHighlighted: Bool
//    var shape: S
//    var size: CGFloat
//    @EnvironmentObject var songViewModel: NowPlayingViewModel
//
//    var body: some View {
//        ZStack {
//            if songViewModel.whiteLevel < 0.3 {
//                if isHighlighted {
//                    shape
//                        .fill(gradient(for: isHighlighted))
//                        .overlay(
//                            shape
//                                .stroke(songViewModel.lighterAccentColor, lineWidth: 2)
//                                .blur(radius: 4)
//                                .offset(x: -2, y: -2)
//                                .mask(shape.fill(LinearGradient(direction: .diagonalTopToBottom, Color.clear, Color.black))))
//                        .overlay(
//                            shape
//                                .stroke(songViewModel.darkerAccentColor, lineWidth: 2)
//                                .blur(radius: 8)
//                                .offset(x: -2, y: -2)
//                                .mask(shape.fill(LinearGradient(direction: .diagonalTopToBottom, Color.black, Color.clear))))
//                        .shadow(color: Color.black.opacity(0.5), radius: 10, x: 5, y: 5)
//                        .shadow(color: Color.white.opacity(0.5), radius: 10, x: -5, y: -5)
//                        .blendMode(.overlay)
//                    shape
//                        .fill(gradient(for: isHighlighted))
//                        .overlay(shape.stroke(LinearGradient(direction: .diagonalTopToBottom, .blackGradient, .black), lineWidth: 2))
//                } else {
//                    shape
//                        .fill(gradient(for: isHighlighted))
//                        .shadow(color: Color.black.opacity(0.5), radius: 10, x: 5, y: 5)
//                        .shadow(color: Color.white.opacity(0.5), radius: 10, x: -5, y: -5)
//                        .blendMode(.overlay)
//                    shape
//                        .fill(LinearGradient(direction: .diagonalTopToBottom, songViewModel.lighterAccentColor, songViewModel.darkerAccentColor))
//                        .overlay(shape.stroke(LinearGradient(direction: .diagonalTopToBottom, .blackGradient, .black), lineWidth: 2))
//                }
//            } else {
//                if isHighlighted {
//                    shape
//                        .fill(gradient(for: isHighlighted))
//                        .overlay(
//                            shape
//                                .stroke(songViewModel.lighterAccentColor, lineWidth: 2)
//                                .blur(radius: 4)
//                                .offset(x: -2, y: -2)
//                                .mask(shape.fill(LinearGradient(direction: .diagonalTopToBottom, Color.clear, Color.black))))
//                        .overlay(
//                            shape
//                                .stroke(songViewModel.darkerAccentColor, lineWidth: 2)
//                                .blur(radius: 8)
//                                .offset(x: -2, y: -2)
//                                .mask(shape.fill(LinearGradient(direction: .diagonalTopToBottom, Color.black, Color.clear))))
//                        .shadow(color: Color.black.opacity(0.7), radius: 8, x: 5, y: 5)
//                        .shadow(color: Color.white.opacity(0.8), radius: 8, x: -5, y: -5)
//                        .blendMode(.overlay)
//                    shape
//                        .fill(gradient(for: isHighlighted))
//                        .overlay(shape.stroke(LinearGradient(direction: .diagonalTopToBottom, .blackGradient, .black), lineWidth: 2))
//                } else {
//                    shape
//                        .fill(gradient(for: isHighlighted))
//                        .shadow(color: Color.black.opacity(0.7), radius: 8, x: 5, y: 5)
//                        .shadow(color: Color.white.opacity(0.8), radius: 8, x: -5, y: -5)
//                        .blendMode(.overlay)
//                    shape
//                        .fill(LinearGradient(direction: .diagonalTopToBottom, songViewModel.lighterAccentColor, songViewModel.darkerAccentColor))
//                        .overlay(shape.stroke(LinearGradient(direction: .diagonalTopToBottom, .blackGradient, .black), lineWidth: 2))
//                }
//            }
//        }
//        .frame(width: size, height: size)
//    }
//
//    private func gradient(for state: Bool) -> LinearGradient {
//        state ? LinearGradient(direction: .diagonalTopToBottom, songViewModel.darkerAccentColor, songViewModel.lighterAccentColor) : LinearGradient(direction: .diagonalTopToBottom, songViewModel.darkerAccentColor, songViewModel.lighterAccentColor)
//    }
//}

//struct NeuToggleBackground<S: Shape>: View {
//    @EnvironmentObject var songViewModel: NowPlayingViewModel
//    var shape: S
//    var lighterColor: Color
//    var darkerColor: Color
//    var size: CGFloat
//    
//    var body: some View {
//        ZStack {
//            if songViewModel.whiteLevel < 0.3 {
//                shape
//                    .fill(gradient(for: songViewModel.isPlaying))
//                    .shadow(color: Color.white.opacity(0.5), radius: 12, x: -5, y: -5)
//                    .shadow(color: Color.black.opacity(0.5), radius: 12, x: 5, y: 5)
//                    .blendMode(.overlay)
//                shape
//                    .fill(gradient(for: songViewModel.isPlaying))
//                    .overlay(shape.stroke(LinearGradient(direction: .diagonalTopToBottom, .blackGradient, .black), lineWidth: 2))
//            } else {
//                shape
//                    .fill(gradient(for: songViewModel.isPlaying))
//                    .shadow(color: Color.white.opacity(0.9), radius: 10, x: -5, y: -5)
//                    .shadow(color: Color.black.opacity(0.5), radius: 10, x: 5, y: 5)
//                    .blendMode(.overlay)
//                shape
//                    .fill(gradient(for: songViewModel.isPlaying))
//                    .overlay(shape.stroke(LinearGradient(direction: .diagonalTopToBottom, .blackGradient, .black), lineWidth: 2))
//            }
//        }
//        .frame(width: size, height: size)
//    }
//    private func gradient(for state: Bool) -> LinearGradient {
//        state ? LinearGradient(direction: .diagonalTopToBottom, songViewModel.darkerAccentColor, songViewModel.lighterAccentColor) : LinearGradient(direction: .diagonalTopToBottom, songViewModel.lighterAccentColor, songViewModel.darkerAccentColor)
//    }
//}
