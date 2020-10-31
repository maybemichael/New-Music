//
//  MusicPlayerControlsViewController.swift
//  New-Music
//
//  Created by Michael McGrath on 10/19/20.
//

import SwiftUI

class NowPlayingViewController: UIViewController {

    var musicController: MusicController! {
        didSet {
            configureContentView()
        }
    }
    weak var coordinator: MainCoordinator?
    var interactor: Interactor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        configureContentView()
    }
    
    private func configureContentView() {
        let contentView = UIHostingController(rootView: NowPlayingFullView(isPresented: .constant(true), musicController: musicController).environmentObject(musicController.nowPlayingViewModel))
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        addChild(contentView)
        contentView.didMove(toParent: self)
        view.addSubview(contentView.view)
        contentView.view.anchor(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        view.addGestureRecognizer(panGesture)
    }

    
    @objc func handleGesture(_ sender: UIPanGestureRecognizer) {
        let percentThreshold:CGFloat = 0.25

        // convert y-position to downward pull progress (percentage)
        let translation = sender.translation(in: view)
        let verticalMovement = translation.y / (view.bounds.height * 1.2)
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let progress = CGFloat(downwardMovementPercent)
        guard let interactor = interactor else { return }

        switch sender.state {
        case .began:
            interactor.isStarted = true
            dismiss(animated: true, completion: nil)
            print("Sender state .began: \(sender.state)")
        case .changed:
            interactor.shouldFinish = progress > percentThreshold
            interactor.update(progress)
            print("Sender state .changed: \(sender.state)")
        case .cancelled:
            interactor.isStarted = false
            interactor.cancel()
            print("Sender state .cancelled: \(sender.state)")
        case .ended:
            interactor.isStarted = false
            interactor.shouldFinish ? interactor.finish() : interactor.cancel()
            print("Sender state .ended: \(sender.state)")
        default:
            break
        }
    }
}
