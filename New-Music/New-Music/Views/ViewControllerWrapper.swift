//
//  ViewControllerWrapper.swift
//  New-Music
//
//  Created by Michael McGrath on 10/26/20.
//

import SwiftUI

struct ViewControllerWrapper: UIViewControllerRepresentable {
    
    let viewController: UIViewController?
    typealias UIViewControllerType = UIViewController
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ViewControllerWrapper>) -> UIViewController {
        guard let controller = viewController else {
            return UIViewController()
        }
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<ViewControllerWrapper>) {
        
    }
    
}
