//
//  SectionHeader.swift
//  New-Music
//
//  Created by Michael McGrath on 11/11/20.
//

import UIKit

class SectionHeader: UICollectionReusableView {
    static let identifier = "SectionHeader"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    let topSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .opaqueSeparator
        return view
    }()
    
    let bottomSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .opaqueSeparator
        view.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(topSeparatorView)
        addSubview(titleLabel)
        topSeparatorView.anchor(top: topAnchor, centerX: centerXAnchor, size: .init(width: UIScreen.main.bounds.width - 40, height: 0.5))
        titleLabel.anchor(top: topSeparatorView.bottomAnchor, leading: leadingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("Storyboards suck")
    }
}
