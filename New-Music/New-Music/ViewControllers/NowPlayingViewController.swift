//
//  MusicPlayerControlsViewController.swift
//  New-Music
//
//  Created by Michael McGrath on 10/19/20.
//

import SwiftUI

class NowPlayingViewController: UIViewController {

    var musicController: MusicController!
    weak var coordinator: MainCoordinator?
    var interactor: Interactor?
    @Namespace var namespace
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        configureContentView()
    }
    
    private func configureContentView() {
        let contentView = UIHostingController(rootView: NowPlayingViewFull(musicController: musicController, namespace: namespace))
        view.backgroundColor = .clear
        addChild(contentView)
        view.addSubview(contentView.view)
        contentView.view.frame = self.view.frame
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        view.addGestureRecognizer(panGesture)
    }

    
    @objc func handleGesture(_ sender: UIPanGestureRecognizer) {
        let percentThreshold:CGFloat = 0.25

        // convert y-position to downward pull progress (percentage)
        let translation = sender.translation(in: view)
        let verticalMovement = translation.y / (view.bounds.height * 1.4)
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let progress = CGFloat(downwardMovementPercent)
        guard let interactor = interactor else { return }

        switch sender.state {
        case .began:
            interactor.isStarted = true
            dismiss(animated: true, completion: nil)
        case .changed:
            interactor.shouldFinish = progress > percentThreshold
            interactor.update(progress)
        case .cancelled:
            interactor.isStarted = false
            interactor.cancel()
        case .ended:
            interactor.isStarted = false
            interactor.shouldFinish
                ? interactor.finish()
                : interactor.cancel()
        default:
            break
        }
    }
}
