//
//  MorePractice.swift
//  New-Music
//
//  Created by Michael McGrath on 10/19/20.
//

import SwiftUI

struct MorePractice: View {
    @State var isPresented = false
    @GestureState private var dragState = DragState.inactive
    @State var position: CGFloat = 0
    var musicController = MusicController()
    var drag2: some Gesture {
        let drag = DragGesture()
            .updating($dragState) { drag, state, transaction in
                state = .dragging(translation: drag.translation)
            }
            .onEnded(onDragEnded)
        return drag
    }
    
    var body: some View {
        ZStack {
            LinearGradient(.sysGrayThree, .nowPlayingBG)
                .edgesIgnoringSafeArea(.all)
            RoundedRectangle(cornerRadius: 12)
                .frame(width: UIScreen.main.bounds.width, height: 250, alignment: .center)
                .gesture(TapGesture()
                    .onEnded({ _ in
                        self.isPresented = true
                })
                         
                )
            }
        .fullScreenCover(isPresented: $isPresented, content: {
            NowPlayingFullScreen(position: 0, musicController: musicController)
        })
        .cornerRadius(15.0)
        .offset(y: self.position + self.dragState.translation.height)
        .animation(self.dragState.isDragging ? nil : .interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
        .gesture(drag2)
        
        
    }
    private func onDragEnded(drag: DragGesture.Value) {
        let verticalDirection = drag.predictedEndLocation.y - drag.location.y
        let cardTopEdgeLocation = self.position + drag.translation.height
        let positionAbove: CGFloat
        let positionBelow: CGFloat
        let closestPosition: CGFloat
        
        if self.position < 0 {
            return
        }
        
        if cardTopEdgeLocation <= CardPosition.middle.offset {
            positionAbove = CardPosition.top.offset
            positionBelow = CardPosition.bottom.offset
        } else {
            positionAbove = CardPosition.top.offset
            positionBelow = CardPosition.bottom.offset
        }
        
        if (cardTopEdgeLocation - positionAbove) < (positionBelow - cardTopEdgeLocation) {
            closestPosition = positionAbove
        } else {
            closestPosition = positionBelow
        }
        
        if verticalDirection > 0 {
            self.position = positionBelow
        } else if verticalDirection < 0 {
            self.position = positionAbove
        } else {
            self.position = closestPosition
        }
        print("Top edge: \(cardTopEdgeLocation)")
    }
}

struct MorePractice_Previews: PreviewProvider {
    static var previews: some View {
        MorePractice()
    }
}

struct FullScreenModal: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text("This is a modal view")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.red)
        .edgesIgnoringSafeArea(.all)
        .onTapGesture {
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct NowPlayingFullScreen: View {
    @GestureState private var dragState = DragState.inactive
    @State var position: CGFloat = 0
    var musicController = MusicController()
    var drag2: some Gesture {
        let drag = DragGesture()
            .updating($dragState) { drag, state, transaction in
                state = .dragging(translation: drag.translation)
            }
            .onEnded(onDragEnded)
        return drag
    }
    
    var body: some View {
        let _ = DragGesture()
            .updating($dragState) { drag, state, transaction in
                state = .dragging(translation: drag.translation)
            }
            .onEnded(onDragEnded)
        ZStack {
//            NowPlayingViewFull(musicController: musicController, songViewModel: musicController.nowPlayingViewModel)
//                .cornerRadius(15.0)
//                .offset(y: self.position + self.dragState.translation.height)
//                .animation(self.dragState.isDragging ? nil : .interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
//                .gesture(drag)
        }
    }
    private func onDragEnded(drag: DragGesture.Value) {
        let verticalDirection = drag.predictedEndLocation.y - drag.location.y
        let cardTopEdgeLocation = self.position + drag.translation.height
        let positionAbove: CGFloat
        let positionBelow: CGFloat
        let closestPosition: CGFloat
        
        if self.position < 0 {
            return
        }
        
        if cardTopEdgeLocation <= CardPosition.middle.offset {
            positionAbove = CardPosition.top.offset
            positionBelow = CardPosition.bottom.offset
        } else {
            positionAbove = CardPosition.top.offset
            positionBelow = CardPosition.bottom.offset
        }
        
        if (cardTopEdgeLocation - positionAbove) < (positionBelow - cardTopEdgeLocation) {
            closestPosition = positionAbove
        } else {
            closestPosition = positionBelow
        }
        
        if verticalDirection > 0 {
            self.position = positionBelow
        } else if verticalDirection < 0 {
            self.position = positionAbove
        } else {
            self.position = closestPosition
        }
        print("Top edge: \(cardTopEdgeLocation)")
    }
}

//struct NowPlayingPlayerView<Content: View> : View {
//    @GestureState private var dragState = DragState.inactive
//    @State var position: CGFloat = 0
//    var top: CGFloat = 0
//    var middle: CGFloat = UIScreen.main.bounds.height / 2
//    var bottom: CGFloat = UIScreen.main.bounds.height
//
//    var content: () -> Content
//    var body: some View {
//        let drag = DragGesture()
//            .updating($dragState) { drag, state, transaction in
//                state = .dragging(translation: drag.translation)
//            }
//            .onEnded(onDragEnded)
//
//        return Group {
//            Handle()
//            self.content()
//        }
//        .frame(height: UIScreen.main.bounds.height)
//        .background(LinearGradient(.sysGrayThree, .nowPlayingBG))
//        .cornerRadius(15.0)
//        .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.13), radius: 10.0)
//        .offset(y: self.position + self.dragState.translation.height)
//        .animation(self.dragState.isDragging ? nil : .interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
//        .gesture(drag)
//    }
//
//    private func onDragEnded(drag: DragGesture.Value) {
//        let verticalDirection = drag.predictedEndLocation.y - drag.location.y
//        let cardTopEdgeLocation = self.position + drag.translation.height
//        let positionAbove: CGFloat
//        let positionBelow: CGFloat
//        let closestPosition: CGFloat
//
//        if self.position < 0 {
//            return
//        }
//
//        if cardTopEdgeLocation <= CardPosition.middle.offset {
//            positionAbove = CardPosition.top.offset
//            positionBelow = CardPosition.bottom.offset
//        } else {
//            positionAbove = CardPosition.top.offset
//            positionBelow = CardPosition.bottom.offset
//        }
//
//        if (cardTopEdgeLocation - positionAbove) < (positionBelow - cardTopEdgeLocation) {
//            closestPosition = positionAbove
//        } else {
//            closestPosition = positionBelow
//        }
//
//        if verticalDirection > 0 {
//            self.position = positionBelow
//        } else if verticalDirection < 0 {
//            self.position = positionAbove
//        } else {
//            self.position = closestPosition
//        }
//        print("Top edge: \(cardTopEdgeLocation)")
//    }
//}
//
//enum CardPosition: Double {
//    case top = 1.0
//    case middle = 0.5
//    case bottom = 0.0
//
//    var offset: CGFloat {
//        let screenHeight = UIScreen.main.bounds.height
//        return screenHeight - (screenHeight * CGFloat(self.rawValue))
//    }
//}
//
//enum DragState {
//    case inactive
//    case dragging(translation: CGSize)
//
//    var translation: CGSize {
//        switch self {
//        case .inactive:
//            return .zero
//        case .dragging(let translation):
//            return translation
//        }
//    }
//
//    var isDragging: Bool {
//        switch self {
//        case .inactive:
//            return false
//        case .dragging:
//            return true
//        }
//    }
//}
//
//struct Handle : View {
//    private let handleThickness = CGFloat(5.0)
//    var body: some View {
//        RoundedRectangle(cornerRadius: handleThickness / 2.0)
//            .frame(width: 40, height: handleThickness)
//            .foregroundColor(Color.secondary)
//            .padding(5)
//    }
//}
