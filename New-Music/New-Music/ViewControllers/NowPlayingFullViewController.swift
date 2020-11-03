//
//  MusicPlayerControlsViewController.swift
//  New-Music
//
//  Created by Michael McGrath on 10/19/20.
//

import SwiftUI

class NowPlayingFullViewController: UIViewController {

    var musicController: MusicController! {
        didSet {
            configureContentView()
        }
    }
    weak var coordinator: MainCoordinator?
    var interactor: Interactor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureContentView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    private func configureContentView() {
        let contentView = UIHostingController(rootView: NowPlayingFullView(isPresented: .constant(true), musicController: musicController).environmentObject(musicController.nowPlayingViewModel))
        let backgroundView = UIVisualEffectView()
        backgroundView.effect = UIBlurEffect(style: .light)
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.backgroundColor = .clear
        view.addSubview(backgroundView)
        backgroundView.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor)
//        backgroundView.contentView.addSubview(contentView.view)
        addChild(contentView)
        contentView.didMove(toParent: self)
        view.addSubview(contentView.view)
        contentView.view.frame = view.frame
//        contentView.view.anchor(top: backgroundView.contentView.topAnchor, leading: backgroundView.contentView.leadingAnchor, trailing: backgroundView.contentView.trailingAnchor, bottom: backgroundView.contentView.bottomAnchor)
        contentView.view.backgroundColor = .clear
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
//        contentView.view.addGestureRecognizer(panGesture)
    }

    
//    @objc func handleGesture(_ sender: UIPanGestureRecognizer) {
//        let percentThreshold:CGFloat = 0.25
//
//        // convert y-position to downward pull progress (percentage)
//        let translation = sender.translation(in: view)
//        let verticalMovement = translation.y / (view.bounds.height * 1.2)
//        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
//        let downwardMovementPercent = fminf(downwardMovement, 1.0)
//        let progress = CGFloat(downwardMovementPercent)
//        guard let interactor = interactor else { return }
//
//        switch sender.state {
//        case .began:
//            interactor.isTransitionInProgress = true
//            dismiss(animated: true, completion: nil)
//            print("Sender state .began: \(sender.state)")
//        case .changed:
//            interactor.shouldFinish = progress > percentThreshold
//            interactor.update(progress)
//            print("Sender state .changed: \(sender.state)")
//        case .cancelled:
//            interactor.cancel()
//            interactor.contextData?.cancelInteractiveTransition()
//            interactor.isTransitionInProgress = false
//            print("Sender state .cancelled: \(sender.state)")
//        case .ended:
//            interactor.shouldFinish ? interactor.finish() : interactor.cancel()
//            interactor.isTransitionInProgress = false
//            print("Sender state .ended: \(sender.state)")
//        default:
//            break
//        }
//    }
}
